{ lowPrio, newScope, pkgs, lib, stdenv
, fetchzip, wrapCCWith, overrideCC
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
  version = "11.2.0";

  # fetchzip to unpack makes debug cycle much better
  gcc_src = fetchzip {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "0aj1l0wkdbd5l2h5qybw0i5nwqbhqx89klnp7m5mwr63gmjfxwmi";
  };

  gcc_meta = {
    description = "GNU Compiler Collection";
    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as
      libraries for these languages (libstdc++, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';
    homepage = "https://gcc.gnu.org/";
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
    callPackage = newScope (tools // { inherit version gcc_tools_meta gcc_src buildGccTools; });

  mkExtraBuildCommands0 = _: "";

  mkExtraBuildCommands = _: "";

  in {

    gcc-unwrapped = callPackage ./gcc { };

    # TODO: support libcxx? is there even an usecase for that?
    gcc = if stdenv.cc.isClang then tools.libcxxGcc else tools.libstdcxxGcc;

    libcxxGcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      extraPackages = [
        targetGccLibraries.libgcc
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

    libstdcxxGcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = targetGccLibraries.libstdcxx;
      extraPackages = [
        targetGccLibraries.libgcc
      ];
      extraBuildCommands = mkExtraBuildCommands cc;
    };

	# Below, is the GCC Next Gen bootstrapping logic. It handles building a
	# fully GCC toolchain from scratch via Nix. No LLVM toolchain should be
	# pulled in. We should deduplicate this bootstrapping with its LLVM
	# equivalence one GCC "old gen" is gone.

    gccUseGccNg = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = targetGccLibraries.libstdcxx;
      extraPackages = [
        targetGccLibraries.libgcc
      ] ++ lib.optionals (!stdenv.targetPlatform.isWasm) [
        targetGccLibraries.libunwind
      ];
      extraBuildCommands = ''
        echo "-rtlib=libgcc -Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.libgcc}/lib" >> $out/nix-support/cc-cflags
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
        targetGccLibraries.libgcc
      ];
      extraBuildCommands = ''
        echo "-rtlib=libgcc" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.libgcc}/lib" >> $out/nix-support/cc-cflags
        echo "-nostdlib++" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    gccNoLibc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc;
      extraPackages = [
        targetGccLibraries.libgcc
      ];
      extraBuildCommands = ''
        echo "-rtlib=libgcc" >> $out/nix-support/cc-cflags
        echo "-B${targetGccLibraries.libgcc}/lib" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands cc;
    };

    gccNoLibgcc = wrapCCWith rec {
      cc = tools.gcc-unwrapped;
      libcxx = null;
      bintools = bintoolsNoLibc;
      extraPackages = [ ];
      extraBuildCommands = ''
        echo "-nostartfiles" >> $out/nix-support/cc-cflags
      '' + mkExtraBuildCommands0 cc;
    };

  });

  libraries = lib.makeExtensible (libraries: let
    callPackage = newScope (libraries // buildGccTools // { inherit version gcc_libs_meta gcc_src; });
  in {

    libgcc = callPackage ./libgcc {
      stdenv = overrideCC stdenv buildGccTools.gccNoLibgcc;
    };

    stdenv = overrideCC stdenv buildGccTools.gcc;

    libstdcxxStdenv = overrideCC stdenv buildGccTools.libstdcxxGcc;

    libada = callPackage ./libada { };

    libgfortran = callPackage ./libgfortran { };

    libstdcxx = callPackage ./libstdcxx {
      stdenv = overrideCC stdenv buildGccTools.gccNoLibstdcxx;
    };

    # TODO add (gnu) libunwind here? can already be built separately aiui
  });

in { inherit tools libraries; } // libraries // tools
