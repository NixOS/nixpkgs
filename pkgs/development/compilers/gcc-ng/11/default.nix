{ lowPrio, newScope, pkgs, lib, stdenv, cmake
, fetchurl
, wrapCCWith
, overrideCC
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
    callPackage = newScope (tools // {
      inherit stdenv version src buildGccTools gcc_tools_meta;
    });

  in {

    gcc-unwrapped = callPackage ./gcc { };

    # TODO: support libcxx? is there even an usecase for that?
    gcc = tools.libstdcxxGcc;

    libstdcxxGcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = targetGccLibraries.libstdcxx;
    };

    gccNoLibstdcxx = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintools;
    };

    gccNoLibc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc;
    };

    # TODO: gccNoLibgcc, gccNoLibgccWithLibc (if possible?)

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildGccTools // {
      inherit stdenv version src gcc_libs_meta;
    });
  in {

    stdenv = overrideCC stdenv buildGccTools.gcc;

    libstdcxxStdenv = overrideCC stdenv buildGccTools.libstdcxxGcc;

    libgcc = callPackage ./libgcc { };

    libada = callPackage ./libada { };

    libgfortran = callPackage ./libgfortran { };

    libstdcxx = callPackage ./libstdc++ { };

    # TODO add (gnu) libunwind here? can already be built separately aiui

  });

in { inherit tools libraries; } // libraries // tools
