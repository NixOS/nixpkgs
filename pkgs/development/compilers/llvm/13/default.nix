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
, officialRelease ? { version = "13.0.1"; sha256 = "06dv6h5dmvzdxbif2s8njki6h32796v368dyb5945x8gjj72xh7k"; }
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
    src = monorepoSrc;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // args // metadata
      # Previously monorepoSrc was erroneously not being passed through.
      // { monorepoSrc = null; } # Preserve a bug during #307211, TODO: remove; causes llvm 13 rebuild.
    );
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
        # When cross-compiling we configure llvm-config-native with an approximation
        # of the flags used for the normal LLVM build. To avoid the need for building
        # a native libLLVM.so (which would fail) we force llvm-config to be linked
        # statically against the necessary LLVM components always.
        ../common/llvm/llvm-config-link-static.patch

        ./llvm/gnu-install-dirs.patch

        # Fix random compiler crashes: https://bugs.llvm.org/show_bug.cgi?id=50611
        (fetchpatch {
          url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/4764a4f8c920912a2bfd8b0eea57273acfe0d8a8/trunk/no-strict-aliasing-DwarfCompileUnit.patch";
          sha256 = "18l6mrvm2vmwm77ckcnbjvh6ybvn72rhrb799d4qzwac4x2ifl7g";
          stripLen = 1;
        })

        # Fix musl build.
        (fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/5cd554303ead0f8891eee3cd6d25cb07f5a7bf67.patch";
          relative = "llvm";
          hash = "sha256-XPbvNJ45SzjMGlNUgt/IgEvM2dHQpDOe6woUJY+nUYA=";
        })

        # Backport gcc-13 fixes with missing includes.
        (fetchpatch {
          name = "signals-gcc-13.patch";
          url = "https://github.com/llvm/llvm-project/commit/ff1681ddb303223973653f7f5f3f3435b48a1983.patch";
          hash = "sha256-CXwYxQezTq5vdmc8Yn88BUAEly6YZ5VEIA6X3y5NNOs=";
          stripLen = 1;
        })
        (fetchpatch {
          name = "base64-gcc-13.patch";
          url = "https://github.com/llvm/llvm-project/commit/5e9be93566f39ee6cecd579401e453eccfbe81e5.patch";
          hash = "sha256-PAwrVrvffPd7tphpwCkYiz+67szPRzRB2TXBvKfzQ7U=";
          stripLen = 1;
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
        # Revert of https://reviews.llvm.org/D100879
        # The malloc alignment assumption is incorrect for jemalloc and causes
        # mis-compilation in firefox.
        # See: https://bugzilla.mozilla.org/show_bug.cgi?id=1741454
        ./clang/revert-malloc-alignment-assumption.patch
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
          ./lldb/gnu-install-dirs.patch
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
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + lib.optionalString (!stdenv.targetPlatform.isWasm) ''
        echo "--unwindlib=libunwind" >> $out/nix-support/cc-cflags
        echo "-L${targetLlvmLibraries.libunwind}/lib" >> $out/nix-support/cc-ldflags
      '' + lib.optionalString (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false) ''
        echo "-lunwind" >> $out/nix-support/cc-ldflags
      '' + lib.optionalString stdenv.targetPlatform.isWasm ''
        echo "-fno-exceptions" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    clangNoLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    clangNoLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    clangNoCompilerRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands0 cc;
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
    callPackage = newScope (libraries // buildLlvmTools // args // metadata
      # Previously monorepoSrc was erroneously not being passed through.
      // { monorepoSrc = null; } # Preserve a bug during #307211, TODO: remove; causes llvm 13 rebuild.
    );
  in {

    compiler-rt-libc = callPackage ../common/compiler-rt {
      patches = [
        ./compiler-rt/codesign.patch # Revert compiler-rt commit that makes codesign mandatory
        ./compiler-rt/X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
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
      # TODO: remove this, causes LLVM 13 packages rebuild.
      inherit (metadata) monorepoSrc; # Preserve bug during #307211 refactor.
    };

    libunwind = callPackage ../common/libunwind {
      patches = [
        ./libunwind/gnu-install-dirs.patch
      ];
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    openmp = callPackage ../common/openmp {
      patches = [
        # Fix cross.
        (fetchpatch {
          url = "https://github.com/llvm/llvm-project/commit/5e2358c781b85a18d1463fd924d2741d4ae5e42e.patch";
          hash = "sha256-UxIlAifXnexF/MaraPW0Ut6q+sf3e7y1fMdEv1q103A=";
        })
      ];
    };
  });
  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];

in { inherit tools libraries; inherit (metadata) release_version; } // (noExtend libraries) // (noExtend tools)
