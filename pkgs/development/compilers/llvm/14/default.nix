{ lowPrio, newScope, pkgs, lib, stdenv
, preLibcCrossHeaders
, substitute, substituteAll, fetchFromGitHub, fetchpatch
, overrideCC, wrapCCWith, wrapBintoolsWith
, buildLlvmTools # tools, but from the previous stage, for cross
, targetLlvmLibraries # libraries, but from the next stage, for cross
, targetLlvm
# This is the default binutils, but with *this* version of LLD rather
# than the default LLVM version's, if LLD is the choice. We use these for
# the `useLLVM` bootstrapping below.
, bootBintoolsNoLibc ?
    if stdenv.targetPlatform.linker == "lld"
    then null
    else pkgs.bintoolsNoLibc
, bootBintools ?
    if stdenv.targetPlatform.linker == "lld"
    then null
    else pkgs.bintools
, darwin
# LLVM release information; specify one of these but not both:
, gitRelease ? null
  # i.e.:
  # {
  #   version = /* i.e. "15.0.0" */;
  #   rev = /* commit SHA */;
  #   rev-version = /* human readable version; i.e. "unstable-2022-26-07" */;
  #   sha256 = /* checksum for this release, can omit if specifying your own `monorepoSrc` */;
  # }
, officialRelease ? { version = "14.0.6"; sha256 = "sha256-vffu4HilvYwtzwgq+NlS26m65DGbp6OSSne2aje1yJE="; }
  # i.e.:
  # {
  #   version = /* i.e. "15.0.0" */;
  #   candidate = /* optional; if specified, should be: "rcN" */
  #   sha256 = /* checksum for this release, can omit if specifying your own `monorepoSrc` */;
  # }
# By default, we'll try to fetch a release from `github:llvm/llvm-project`
# corresponding to the `gitRelease` or `officialRelease` specified.
#
# You can provide your own LLVM source by specifying this arg but then it's up
# to you to make sure that the LLVM repo given matches the release configuration
# specified.
, monorepoSrc ? null
# Allows passthrough to packages via newScope. This makes it possible to
# do `(llvmPackages.override { <someLlvmDependency> = bar; }).clang` and get
# an llvmPackages whose packages are overridden in an internally consistent way.
, ...
}@args:

assert
  lib.assertMsg
    (lib.xor
      (gitRelease != null)
      (officialRelease != null))
    ("must specify `gitRelease` or `officialRelease`" +
      (lib.optionalString (gitRelease != null) " — not both"));
let
  monorepoSrc' = monorepoSrc;
in let

  metadata = rec {
    # Import releaseInfo separately to avoid infinite recursion
    inherit (import ../common/common-let.nix { inherit lib gitRelease officialRelease; }) releaseInfo;
    inherit (releaseInfo) release_version version;
    inherit (import ../common/common-let.nix { inherit lib fetchFromGitHub release_version gitRelease officialRelease monorepoSrc'; }) llvm_meta monorepoSrc;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // args // metadata);
    mkExtraBuildCommands0 = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${metadata.release_version}/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
    mkExtraBuildCommands = cc: mkExtraBuildCommands0 cc + ''
      ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
      ln -s "${targetLlvmLibraries.compiler-rt.out}/share" "$rsrc/share"
    '';

  bintoolsNoLibc' =
    if bootBintoolsNoLibc == null
    then tools.bintoolsNoLibc
    else bootBintoolsNoLibc;
  bintools' =
    if bootBintools == null
    then tools.bintools
    else bootBintools;

  in {

    libllvm = callPackage ../common/llvm {
      patches = [
        ./llvm/gnu-install-dirs.patch

        # Fix musl build.
        (fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/5cd554303ead0f8891eee3cd6d25cb07f5a7bf67.patch";
          relative = "llvm";
          hash = "sha256-XPbvNJ45SzjMGlNUgt/IgEvM2dHQpDOe6woUJY+nUYA=";
        })
        # fix RuntimeDyld usage on aarch64-linux (e.g. python312Packages.numba tests)
        (fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/2e1b838a889f9793d4bcd5dbfe10db9796b77143.patch";
          relative = "llvm";
          hash = "sha256-Ot45P/iwaR4hkcM3xtLwfryQNgHI6pv6ADjv98tgdZA=";
        })
      ];
      pollyPatches = [
        ./llvm/gnu-install-dirs-polly.patch
      ];
    };

    # `llvm` historically had the binaries.  When choosing an output explicitly,
    # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
    llvm = tools.libllvm;

    libclang = callPackage ../common/clang {
      patches = [
        ./clang/purity.patch
        # https://reviews.llvm.org/D51899
        ./clang/gnu-install-dirs.patch
        ../common/clang/add-nostdlibinc-flag.patch
        (substituteAll {
          src = ../common/clang/clang-11-15-LLVMgold-path.patch;
          libllvmLibdir = "${tools.libllvm.lib}/lib";
        })
      ];
    };

    clang-unwrapped = tools.libclang;

    llvm-manpages = lowPrio (tools.libllvm.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    clang-manpages = lowPrio (tools.libclang.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    # TODO: lldb/docs/index.rst:155:toctree contains reference to nonexisting document 'design/structureddataplugins'
    # lldb-manpages = lowPrio (tools.lldb.override {
    #   enableManpages = true;
    #   python3 = pkgs.python3;  # don't use python-boot
    # });

    # pick clang appropriate for package set we are targeting
    clang =
      /**/ if stdenv.targetPlatform.libc == null then tools.clangNoLibc
      else if stdenv.targetPlatform.useLLVM or false then tools.clangUseLLVM
      else if (pkgs.targetPackages.stdenv or stdenv).cc.isGNU then tools.libstdcxxClang
      else tools.libcxxClang;

    libstdcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      # libstdcxx is taken from gcc in an ad-hoc way in cc-wrapper.
      libcxx = null;
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    libcxxClang = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    lld = callPackage ../common/lld {
      patches = [
        ./lld/gnu-install-dirs.patch
        ./lld/fix-root-src-dir.patch
      ];
    };

    lldb = callPackage ../common/lldb.nix {
      patches =
        let
          resourceDirPatch = callPackage
            ({ substituteAll, libclang }: substituteAll
              {
                src = ./lldb/resource-dir.patch;
                clangLibDir = "${libclang.lib}/lib";
              })
            { };
        in
        [
          ./lldb/procfs.patch
          resourceDirPatch
          ../common/lldb/gnu-install-dirs.patch
        ]
        # This is a stopgap solution if/until the macOS SDK used for x86_64 is
        # updated.
        #
        # The older 10.12 SDK used on x86_64 as of this writing has a `mach/machine.h`
        # header that does not define `CPU_SUBTYPE_ARM64E` so we replace the one use
        # of this preprocessor symbol in `lldb` with its expansion.
        #
        # See here for some context:
        # https://github.com/NixOS/nixpkgs/pull/194634#issuecomment-1272129132
        ++ lib.optional (
          stdenv.targetPlatform.isDarwin
            && !stdenv.targetPlatform.isAarch64
            && (lib.versionOlder darwin.apple_sdk.sdk.version "11.0")
        ) ./lldb/cpu_subtype_arm64e_replacement.patch;
    };

    # Below, is the LLVM bootstrapping logic. It handles building a
    # fully LLVM toolchain from scratch. No GCC toolchain should be
    # pulled in. As a consequence, it is very quick to build different
    # targets provided by LLVM and we can also build for what GCC
    # doesn’t support like LLVM. Probably we should move to some other
    # file.

    bintools-unwrapped = callPackage ../common/bintools.nix { };

    bintoolsNoLibc = wrapBintoolsWith {
      bintools = tools.bintools-unwrapped;
      libc = preLibcCrossHeaders;
    };

    bintools = wrapBintoolsWith {
      bintools = tools.bintools-unwrapped;
    };

    clangUseLLVM = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ] ++ lib.optionals (!stdenv.targetPlatform.isWasm) [
        targetLlvmLibraries.libunwind
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags =
        [ "-rtlib=compiler-rt"
          "-Wno-unused-command-line-argument"
          "-B${targetLlvmLibraries.compiler-rt}/lib"
        ]
        ++ lib.optional (!stdenv.targetPlatform.isWasm) "--unwindlib=libunwind"
        ++ lib.optional
          (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false)
          "-lunwind"
        ++ lib.optional stdenv.targetPlatform.isWasm "-fno-exceptions";
      nixSupport.cc-ldflags = lib.optionals (!stdenv.targetPlatform.isWasm) [ "-L${targetLlvmLibraries.libunwind}/lib" ];
    };

    clangNoLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags = [
        "-rtlib=compiler-rt"
        "-B${targetLlvmLibraries.compiler-rt}/lib"
        "-nostdlib++"
      ];
    };

    clangNoLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
      nixSupport.cc-cflags = [
        "-rtlib=compiler-rt"
        "-B${targetLlvmLibraries.compiler-rt}/lib"
      ];
    };

    clangNoCompilerRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [ ];
      extraBuildCommands = mkExtraBuildCommands0 cc;
      nixSupport.cc-cflags = [ "-nostartfiles" ];
    };

    clangNoCompilerRtWithLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [ ];
      extraBuildCommands = mkExtraBuildCommands0 cc;
    };

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // args // metadata);
  in {

    compiler-rt-libc = callPackage ../common/compiler-rt {
      patches = [
        ./compiler-rt/codesign.patch # Revert compiler-rt commit that makes codesign mandatory
        ./compiler-rt/X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
        ./compiler-rt/gnu-install-dirs.patch
        # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
        # extra `/`.
        ./compiler-rt/normalize-var.patch
        # Prevent a compilation error on darwin
        ./compiler-rt/darwin-targetconditionals.patch
        ../common/compiler-rt/darwin-plistbuddy-workaround.patch
        ./compiler-rt/armv7l.patch
        # Fix build on armv6l
        ../common/compiler-rt/armv6-mcr-dmb.patch
        ../common/compiler-rt/armv6-sync-ops-no-thumb.patch
        ../common/compiler-rt/armv6-no-ldrexd-strexd.patch
        ../common/compiler-rt/armv6-scudo-no-yield.patch
        ../common/compiler-rt/armv6-scudo-libatomic.patch
      ];
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRtWithLibc
               else stdenv;
    };

    compiler-rt-no-libc = callPackage ../common/compiler-rt {
      patches = [
        ./compiler-rt/codesign.patch # Revert compiler-rt commit that makes codesign mandatory
        ./compiler-rt/X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
        ./compiler-rt/gnu-install-dirs.patch
        # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
        # extra `/`.
        ./compiler-rt/normalize-var.patch
        # Prevent a compilation error on darwin
        ./compiler-rt/darwin-targetconditionals.patch
        ../common/compiler-rt/darwin-plistbuddy-workaround.patch
        ./compiler-rt/armv7l.patch
        # Fix build on armv6l
        ../common/compiler-rt/armv6-mcr-dmb.patch
        ../common/compiler-rt/armv6-sync-ops-no-thumb.patch
        ../common/compiler-rt/armv6-no-ldrexd-strexd.patch
        ../common/compiler-rt/armv6-scudo-no-yield.patch
        ../common/compiler-rt/armv6-scudo-libatomic.patch
      ];
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRt
               else stdenv;
    };

    # N.B. condition is safe because without useLLVM both are the same.
    compiler-rt = if stdenv.hostPlatform.isAndroid
      then libraries.compiler-rt-libc
      else libraries.compiler-rt-no-libc;

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ../common/libcxx {
      patches = [
        (substitute {
          src = ../common/libcxxabi/wasm.patch;
          replacements = [
            "--replace-fail" "/cmake/" "/llvm/cmake/"
          ];
        })
      ] ++ lib.optionals stdenv.hostPlatform.isMusl [
        (substitute {
          src = ../common/libcxx/libcxx-0001-musl-hacks.patch;
          replacements = [
            "--replace-fail" "/include/" "/libcxx/include/"
          ];
        })
      ];
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    libunwind = callPackage ../common/libunwind {
      patches = [
        ./libunwind/gnu-install-dirs.patch
      ];
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    openmp = callPackage ../common/openmp {
      patches = [
        ./openmp/gnu-install-dirs.patch
        ./openmp/run-lit-directly.patch
      ];
    };
  });
  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];

in { inherit tools libraries; inherit (metadata) release_version; } // (noExtend libraries) // (noExtend tools)
