{ lowPrio, newScope, pkgs, lib, stdenv
, fetchurl, wrapCCWith, overrideCC
, preLibcCrossHeaders
, buildGccTools # tools, but from the previous stage, for cross
, targetGccLibraries # libraries, but from the next stage, for cross
# This is the default binutils, but with *this* version of LLD rather
# than the default LLVM verion's, if LLD is the choice. We use these for
# the `useLLVM` bootstrapping below.
, bintoolsNoLibc
, bintools
, darwin
}:

let
  version = "11.1.0";

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "1pwxrjhsymv90xzh0x42cxfnmhjinf2lnrrf3hj5jq1rm2w6yjjc";
  };

  gcc_meta = {
    maintainers = with lib.maintainers; [ ericson231 sternenseemann ];
  };
  gcc_libs_meta = gcc_meta // {
    license     = lib.licenses.lgpl3Plus;
    platforms   = lib.platforms.all;
  };
  gcc_tools_meta = gcc_meta // {
    license     = lib.licenses.gpl3Plus;
    platforms   = lib.platforms.unix;
  };

  tools = lib.makeExtensible (tools: let
    callPackage = newScope (tools // { inherit src buildGccTools; });

  mkExtraBuildCommands0 = _: "";

  mkExtraBuildCommands = _: "";

  in {

    gcc-unwrapped = callPackage ./gcc {
      inherit gcc_tools_meta;
    };

    gcc = if stdenv.cc.isClang then tools.libcxxGcc else tools.libstdcxxGcc;

    libstdcxxGcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      # libstdcxx is taken from gcc in an ad-hoc way in cc-wrapper.
      libcxx = null;
      extraPackages = [
        targetGccLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    libcxxGcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = targetGccLibraries.libcxx;
      extraPackages = [
        targetGccLibraries.libcxxabi
        targetGccLibraries.compiler-rt
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    # Below, is the LLVM bootstrapping logic. It handles building a
    # fully LLVM toolchain from scratch. No GCC toolchain should be
    # pulled in. As a consequence, it is very quick to build different
    # targets provided by LLVM and we can also build for what GCC
    # doesn’t support like LLVM. Probably we should move to some other
    # file.

    gccUseLLVM = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = targetGccLibraries.libcxx;
      extraPackages = [
        targetGccLibraries.libcxxabi
        targetGccLibraries.compiler-rt
      ] ++ lib.optionals (!stdenv.targetPlatform.isWasm) [
        targetGccLibraries.libunwind
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + lib.optionalString (!stdenv.targetPlatform.isWasm) ''
        echo "--unwindlib=libunwind" >> $out/nix-support/cc-cflags
      '' + lib.optionalString (!stdenv.targetPlatform.isWasm && stdenv.targetPlatform.useLLVM or false) ''
        echo "-lunwind" >> $out/nix-support/cc-ldflags
      '' + lib.optionalString stdenv.targetPlatform.isWasm ''
        echo "-fno-exceptions" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    gccNoLibstdcxx = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      extraPackages = [
        targetGccLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    gccNoLibc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc;
      extraPackages = [
        targetGccLibraries.compiler-rt
      ];
      extraBuildCommands = ''
        echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.compiler-rt}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    gccNoCompilerRt = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc;
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands0 cc;
    };

    gccNoCompilerRtWithLibc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      extraBuildCommands = mkExtraBuildCommands0 cc;
    };

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildGccTools // { inherit version src; });
  in {

    compiler-rt-libc = callPackage ./compiler-rt {
      inherit gcc_libs_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildGccTools.gccNoCompilerRtWithLibc
               else stdenv;
    };

    compiler-rt-no-libc = callPackage ./compiler-rt {
      inherit gcc_libs_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildGccTools.gccNoCompilerRt
               else stdenv;
    };

    # N.B. condition is safe because without useLLVM both are the same.
    compiler-rt = if stdenv.hostPlatform.isAndroid
      then libraries.compiler-rt-libc
      else libraries.compiler-rt-no-libc;

    stdenv = overrideCC stdenv buildGccTools.gcc;

    libcxxStdenv = overrideCC stdenv buildGccTools.libcxxGcc;

    libcxx = callPackage ./libcxx {
      inherit gcc_libs_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildGccTools.gccNoLibstdcxx
               else stdenv;
    };

    libcxxabi = callPackage ./libcxxabi {
      inherit gcc_libs_meta;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildGccTools.gccNoLibstdcxx
               else stdenv;
    };

    libunwind = callPackage ./libunwind {
      inherit gcc_libs_meta;
      inherit (buildGccTools) llvm;
      stdenv = if stdenv.hostPlatform.useLLVM or false
               then overrideCC stdenv buildGccTools.gccNoLibstdcxx
               else stdenv;
    };

    openmp = callPackage ./openmp {
      inherit gcc_libs_meta;
    };
  });

in { inherit tools libraries; } // libraries // tools
