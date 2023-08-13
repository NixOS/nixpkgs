{ lowPrio, newScope, pkgs, lib, stdenv, cmake
, gccForLibs, preLibcCrossHeaders
, libxml2, python3, fetchFromGitHub, overrideCC, wrapCCWith, wrapBintoolsWith
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
  release_version = "14.0.6";
  candidate = ""; # empty or "rcN"
  dash-candidate = lib.optionalString (candidate != "") "-${candidate}";
  rev = ""; # When using a Git commit
  rev-version = ""; # When using a Git commit
  version = if rev != "" then rev-version else "${release_version}${dash-candidate}";
  targetConfig = stdenv.targetPlatform.config;

  monorepoSrc = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = if rev != "" then rev else "llvmorg-${version}";
    sha256 = "sha256-vffu4HilvYwtzwgq+NlS26m65DGbp6OSSne2aje1yJE=";
  };

  llvm_meta = {
    license     = lib.licenses.ncsa;
    maintainers = lib.teams.llvm.members;

    # See llvm/cmake/config-ix.cmake.
    platforms   =
      lib.platforms.aarch64 ++
      lib.platforms.arm ++
      lib.platforms.m68k ++
      lib.platforms.mips ++
      lib.platforms.power ++
      lib.platforms.riscv ++
      lib.platforms.s390x ++
      lib.platforms.wasi ++
      lib.platforms.x86;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit stdenv cmake libxml2 python3 release_version version monorepoSrc buildLlvmTools; });
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

  in {

    libllvm = callPackage ./llvm {
      inherit llvm_meta;
    };

    # `llvm` historically had the binaries.  When choosing an output explicitly,
    # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
    llvm = tools.libllvm;

    libclang = callPackage ./clang {
      inherit llvm_meta;
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
        libcxx.cxxabi
        targetLlvmLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    lld = callPackage ./lld {
      inherit llvm_meta;
    };

    lldb = callPackage ../common/lldb.nix {
      patches =
        let
          resourceDirPatch = callPackage ({ runCommand, libclang }: (runCommand "resource-dir.patch"
            {
              clangLibDir = "${libclang.lib}/lib";
            } ''
            substitute '${./lldb/resource-dir.patch}' "$out" --subst-var clangLibDir
          '')) { };
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
      inherit llvm_meta release_version;
    };

    # Below, is the LLVM bootstrapping logic. It handles building a
    # fully LLVM toolchain from scratch. No GCC toolchain should be
    # pulled in. As a consequence, it is very quick to build different
    # targets provided by LLVM and we can also build for what GCC
    # doesn’t support like LLVM. Probably we should move to some other
    # file.

    bintools-unwrapped = callPackage ./bintools {};

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
        libcxx.cxxabi
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
    callPackage = newScope (libraries // buildLlvmTools // { inherit stdenv cmake libxml2 python3 release_version version monorepoSrc; });
  in {

    compiler-rt-libc = callPackage ./compiler-rt {
      inherit llvm_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoCompilerRtWithLibc
               else stdenv;
    };

    compiler-rt-no-libc = callPackage ./compiler-rt {
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

    libcxx = callPackage ./libcxx {
      inherit llvm_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoLibcxx
               else stdenv;
    };

    libcxxabi = let
      stdenv_ = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildLlvmTools.clangNoLibcxx
               else stdenv;
      cxx-headers = callPackage ./libcxx {
        inherit llvm_meta;
        stdenv = stdenv_;
        headersOnly = true;
      };
    in callPackage ./libcxxabi {
      stdenv = stdenv_;
      inherit llvm_meta cxx-headers;
    };

    libunwind = callPackage ./libunwind {
      inherit llvm_meta;
      stdenv = overrideCC stdenv buildLlvmTools.clangNoLibcxx;
    };

    openmp = callPackage ./openmp {
      inherit llvm_meta targetLlvm;
    };
  });

in { inherit tools libraries release_version; } // libraries // tools
