{ lowPrio, newScope, pkgs, lib, stdenv
, preLibcCrossHeaders
, substitute, substituteAll, fetchFromGitHub, fetchpatch, fetchurl
, overrideCC, wrapCCWith, wrapBintoolsWith
, libxcrypt
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
# Allows passthrough to packages via newScope. This makes it possible to
# do `(llvmPackages.override { <someLlvmDependency> = bar; }).clang` and get
# an llvmPackages whose packages are overridden in an internally consistent way.
, ...
}@args:

let
  candidate = ""; # empty or "rcN"
  dash-candidate = lib.optionalString (candidate != "") "-${candidate}";

  metadata = rec {
    release_version = "12.0.1";
    version = "${release_version}${dash-candidate}"; # differentiating these (variables) is important for RCs
    inherit (import ../common/common-let.nix { inherit lib release_version; }) llvm_meta;
    fetch = name: sha256: fetchurl {
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${metadata.version}/${name}-${metadata.release_version}${candidate}.src.tar.xz";
      inherit sha256;
    };
    clang-tools-extra_src = fetch "clang-tools-extra" "1r9a4fdz9ci58b5z2inwvm4z4cdp6scrivnaw05dggkxz7yrwrb5";
  };

  inherit (metadata) fetch;


  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // args // metadata);
    mkExtraBuildCommands0 = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${metadata.release_version}/include" "$rsrc"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
    mkExtraBuildCommandsBasicRt = cc: mkExtraBuildCommands0 cc + ''
      ln -s "${targetLlvmLibraries.compiler-rt-no-libc.out}/lib" "$rsrc/lib"
      ln -s "${targetLlvmLibraries.compiler-rt-no-libc.out}/share" "$rsrc/share"
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
      src = fetch "llvm" "1pzx9zrmd7r3481sbhwvkms68fwhffpp4mmz45dgrkjpyl2q96kx";
      polly_src = fetch "polly" "1yfm9ixda4a2sx7ak5vswijx4ydk5lv1c1xh39xmd2kh299y4m12";
      patches = [
        # When cross-compiling we configure llvm-config-native with an approximation
        # of the flags used for the normal LLVM build. To avoid the need for building
        # a native libLLVM.so (which would fail) we force llvm-config to be linked
        # statically against the necessary LLVM components always.
        ../common/llvm/llvm-config-link-static.patch
        # Fix llvm being miscompiled by some gccs. See llvm/llvm-project#49955
        # Fix llvm being miscompiled by some gccs. See https://github.com/llvm/llvm-project/issues/49955
        ./llvm/fix-llvm-issue-49955.patch

        ./llvm/gnu-install-dirs.patch
        # On older CPUs (e.g. Hydra/wendy) we'd be getting an error in this test.
        (fetchpatch {
          name = "uops-CMOV16rm-noreg.diff";
          url = "https://github.com/llvm/llvm-project/commit/9e9f991ac033.diff";
          sha256 = "sha256:12s8vr6ibri8b48h2z38f3afhwam10arfiqfy4yg37bmc054p5hi";
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
      src = fetch "clang" "0px4gl27az6cdz6adds89qzdwb1cqpjsfvrldbz9qvpmphrj34bf";
      patches = [
        ./clang/purity.patch
        # https://reviews.llvm.org/D51899
        ./clang/gnu-install-dirs.patch
        (substituteAll {
          src = ../common/clang/clang-11-15-LLVMgold-path.patch;
          libllvmLibdir = "${tools.libllvm.lib}/lib";
        })
      ];
    };

    clang-unwrapped = tools.libclang;

    # disabled until recommonmark supports sphinx 3
    #Llvm-manpages = lowPrio (tools.libllvm.override {
    #  enableManpages = true;
    #  python3 = pkgs.python3;  # don't use python-boot
    #});

    clang-manpages = lowPrio (tools.libclang.override {
      enableManpages = true;
      python3 = pkgs.python3;  # don't use python-boot
    });

    # disabled until recommonmark supports sphinx 3
    # lldb-manpages = lowPrio (tools.lldb.override {
    #   enableManpages = true;
    #   python3 = pkgs.python3;  # don't use python-boot
    # });

    # Wrapper for standalone command line utilities
    clang-tools = callPackage ../common/clang-tools { };

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
      src = fetch "lld" "0qg3fgc7wj34hdkqn21y03zcmsdd01szhhm1hfki63iifrm3y2v9";
      patches = [
        ./lld/gnu-install-dirs.patch
      ];
      inherit (libraries) libunwind;
    };

    lldb = callPackage ../common/lldb.nix {
      src = fetch "lldb" "0g3pj1m3chafavpr35r9fynm85y2hdyla6klj0h28khxs2613i78";
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
        ];
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

    clangWithLibcAndBasicRtAndLibcxx = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = targetLlvmLibraries.libcxx;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt-no-libc
      ] ++ lib.optionals (!stdenv.targetPlatform.isWasm) [
        targetLlvmLibraries.libunwind
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommandsBasicRt cc;
    };

    clangWithLibcAndBasicRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [
        targetLlvmLibraries.compiler-rt-no-libc
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommandsBasicRt cc;
    };

    clangNoLibcWithBasicRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [
        targetLlvmLibraries.compiler-rt-no-libc
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetLlvmLibraries.compiler-rt-no-libc}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommandsBasicRt cc;
    };

    clangNoLibcNoRt = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc';
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands0 cc;
    };

    # This is an "oddly ordered" bootstrap just for Darwin. Probably
    # don't want it otherwise.
    clangNoCompilerRtWithLibc = wrapCCWith rec {
      cc = tools.clang-unwrapped;
      libcxx = null;
      bintools = bintools';
      extraPackages = [ ];
      extraBuildCommands = mkExtraBuildCommands0 cc;
    };

    # Aliases
    clangNoCompilerRt = tools.clangNoLibcNoRt;
    clangNoLibc = tools.clangNoLibcWithBasicRt;
    clangNoLibcxx = tools.clangWithLibcAndBasicRt;
  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildLlvmTools // args // metadata);
  in {

    compiler-rt-libc = callPackage ../common/compiler-rt (let
      stdenv =
        if args.stdenv.hostPlatform.useLLVM or false then
          overrideCC args.stdenv buildLlvmTools.clangWithLibcAndBasicRtAndLibcxx
        else
          args.stdenv;
    in {
      src = fetch "compiler-rt" "1950rg294izdwkaasi7yjrmadc9mzdd5paf0q63jjcq2m3rdbj5l";
      patches = [
        ../common/compiler-rt/7-12-codesign.patch # Revert compiler-rt commit that makes codesign mandatory
        ./compiler-rt/X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
        ./compiler-rt/gnu-install-dirs.patch
        # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
        # extra `/`.
        ./compiler-rt/normalize-var.patch
        ../common/compiler-rt/darwin-plistbuddy-workaround.patch
        ./compiler-rt/armv7l.patch
        # Fix build on armv6l
        ../common/compiler-rt/armv6-mcr-dmb.patch
        ../common/compiler-rt/armv6-sync-ops-no-thumb.patch
        ../common/compiler-rt/armv6-no-ldrexd-strexd.patch
      ];
      inherit stdenv;
    } // lib.optionalAttrs (stdenv.hostPlatform.useLLVM or false) {
      libxcrypt = (libxcrypt.override { inherit stdenv; }).overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--disable-symvers" ];
      });
    });

    compiler-rt-no-libc = callPackage ../common/compiler-rt {
      src = fetch "compiler-rt" "1950rg294izdwkaasi7yjrmadc9mzdd5paf0q63jjcq2m3rdbj5l";
      patches = [
        ../common/compiler-rt/7-12-codesign.patch # Revert compiler-rt commit that makes codesign mandatory
        ./compiler-rt/X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
        ./compiler-rt/gnu-install-dirs.patch
        # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
        # extra `/`.
        ./compiler-rt/normalize-var.patch
        ../common/compiler-rt/darwin-plistbuddy-workaround.patch
        ./compiler-rt/armv7l.patch
        # Fix build on armv6l
        ../common/compiler-rt/armv6-mcr-dmb.patch
        ../common/compiler-rt/armv6-sync-ops-no-thumb.patch
        ../common/compiler-rt/armv6-no-ldrexd-strexd.patch
      ];
      stdenv =
        if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform then
          stdenv
        else
          # TODO: make this branch unconditional next rebuild
          overrideCC stdenv buildLlvmTools.clangNoLibcNoRt;
    };

    compiler-rt =
      # Building the with-libc compiler-rt and WASM doesn't yet work,
      # because wasilibc doesn't provide some expected things. See
      # compiler-rt's file for further details.
      if stdenv.hostPlatform.libc == null || stdenv.hostPlatform.isWasm then
        libraries.compiler-rt-no-libc
      else
        libraries.compiler-rt-libc;

    stdenv = overrideCC stdenv buildLlvmTools.clang;

    libcxxStdenv = overrideCC stdenv buildLlvmTools.libcxxClang;

    libcxx = callPackage ../common/libcxx {
      src = fetchFromGitHub {
        owner = "llvm";
        repo = "llvm-project";
        rev = "refs/tags/llvmorg-${metadata.version}";
        sparseCheckout = [
          "libcxx"
          "libcxxabi"
          "llvm/cmake"
          "llvm/utils"
          "runtimes"
        ];
        hash = "sha256-etxgXIdWxMTmbZ83Hsc0w6Jt5OSQSUEPVEWqLkHsNBY=";
      };
      patches = [
        (substitute {
          src = ../common/libcxxabi/wasm.patch;
          substitutions = [
            "--replace-fail" "/cmake/" "/llvm/cmake/"
          ];
        })
      ] ++ lib.optionals stdenv.hostPlatform.isMusl [
        (substitute {
          src = ../common/libcxx/libcxx-0001-musl-hacks.patch;
          substitutions = [
            "--replace-fail" "/include/" "/libcxx/include/"
          ];
        })
      ];
      stdenv = overrideCC stdenv buildLlvmTools.clangWithLibcAndBasicRt;
    };

    libunwind = callPackage ../common/libunwind {
      src = fetch "libunwind" "192ww6n81lj2mb9pj4043z79jp3cf58a9c2qrxjwm5c3a64n1shb";
      patches = [
        ./libunwind/gnu-install-dirs.patch
      ];
      stdenv = overrideCC stdenv buildLlvmTools.clangWithLibcAndBasicRt;
    };

    openmp = callPackage ../common/openmp {
      src = fetch "openmp" "14dh0r6h2xh747ffgnsl4z08h0ri04azi9vf79cbz7ma1r27kzk0";
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
