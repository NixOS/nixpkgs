{ lowPrio, newScope, pkgs, lib, stdenv, cmake
, preLibcCrossHeaders
, substitute, substituteAll, fetchFromGitHub, fetchpatch
, libxml2, python3, isl, fetchurl, overrideCC, wrapCCWith, wrapBintoolsWith
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
}:

let
  release_version = "12.0.1";
  candidate = ""; # empty or "rcN"
  dash-candidate = lib.optionalString (candidate != "") "-${candidate}";
  version = "${release_version}${dash-candidate}"; # differentiating these (variables) is important for RCs

  fetch = name: sha256: fetchurl {
    url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${name}-${release_version}${candidate}.src.tar.xz";
    inherit sha256;
  };

  clang-tools-extra_src = fetch "clang-tools-extra" "1r9a4fdz9ci58b5z2inwvm4z4cdp6scrivnaw05dggkxz7yrwrb5";

  inherit (import ../common/common-let.nix { inherit lib release_version; }) llvm_meta;

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch buildLlvmTools; });
    mkExtraBuildCommands0 = cc: ''
      rsrc="$out/resource-root"
      mkdir "$rsrc"
      ln -s "${cc.lib}/lib/clang/${release_version}/include" "$rsrc"
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

  in rec {

    libllvm = callPackage ./llvm {
      inherit llvm_meta;
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
          libllvmLibdir = "${libllvm.lib}/lib";
        })
      ];
      inherit clang-tools-extra_src llvm_meta;
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
      inherit llvm_meta;
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
      inherit llvm_meta;
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
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python3 isl release_version version fetch; });
  in {

    compiler-rt-libc = callPackage ../common/compiler-rt {
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
      inherit llvm_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRtWithLibc
               else stdenv;
    };

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
      inherit llvm_meta;
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
      src = fetchFromGitHub {
        owner = "llvm";
        repo = "llvm-project";
        rev = "refs/tags/llvmorg-${version}";
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
      inherit llvm_meta;
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    libunwind = callPackage ../common/libunwind {
      src = fetch "libunwind" "192ww6n81lj2mb9pj4043z79jp3cf58a9c2qrxjwm5c3a64n1shb";
      patches = [
        ./libunwind/gnu-install-dirs.patch
      ];
      inherit llvm_meta;
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
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
      inherit llvm_meta targetLlvm;
    };
  });
  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];

in { inherit tools libraries release_version; } // (noExtend libraries) // (noExtend tools)
