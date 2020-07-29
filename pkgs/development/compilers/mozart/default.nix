{ lib
, fetchFromGitHub
, fetchurl
, cmake
, unzip
, makeWrapper
, boost
, llvmPackages
, llvmPackages_5
, gmp
, emacs
, emacs25-nox
, jre_headless
, tcl
, tk
}:

let stdenv = llvmPackages.stdenv;

in stdenv.mkDerivation rec {
  pname = "mozart2";
  version = "2.0.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/mozart/mozart2/releases/download/v${version}/${name}-Source.zip";
    sha256 = "1mad9z5yzzix87cdb05lmif3960vngh180s2mb66cj5gwh5h9dll";
  };

  # This is a workaround to avoid using sbt.
  # I guess it is acceptable to fetch the bootstrapping compiler in binary form.
  bootcompiler = fetchurl {
    url = "https://github.com/layus/mozart2/releases/download/v2.0.0-beta.1/bootcompiler.jar";
    sha256 = "1hgh1a8hgzgr6781as4c4rc52m2wbazdlw3646s57c719g5xphjz";
  };

  postConfigure = ''
    cp ${bootcompiler} bootcompiler/bootcompiler.jar
  '';

  nativeBuildInputs = [ cmake makeWrapper unzip ];

  # We cannot compile with both gcc and clang, but we need clang during the
  # process, so we compile everything with clang.
  # BUT, we need clang4 for parsing, and a more recent clang for compiling.
  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=${llvmPackages.clang}/bin/clang++"
    "-DCMAKE_C_COMPILER=${llvmPackages.clang}/bin/clang"
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DMOZART_BOOST_USE_STATIC_LIBS=OFF"
    "-DCMAKE_PROGRAM_PATH=${llvmPackages_5.clang}/bin"
    # Rationale: Nix's cc-wrapper needs to see a compile flag (like -c) to
    # infer that it is not a linking call, and stop trashing the command line
    # with linker flags.
    # As it does not recognise -emit-ast, we pass -c immediately overridden
    # by -emit-ast.
    # The remaining is just the default flags that we cannot reuse and need
    # to repeat here.
    "-DMOZART_GENERATOR_FLAGS='-c;-emit-ast;--std=c++0x;-Wno-invalid-noreturn;-Wno-return-type;-Wno-braced-scalar-init'"
    # We are building with clang, as nix does not support having clang and
    # gcc together as compilers and we need clang for the sources generation.
    # However, clang emits tons of warnings about gcc's atomic-base library.
    "-DCMAKE_CXX_FLAGS=-Wno-braced-scalar-init"
  ] ++ lib.optional stdenv.isDarwin "-DCMAKE_FIND_FRAMEWORK=LAST";

  fixupPhase = ''
    wrapProgram $out/bin/oz --set OZEMACS ${emacs}/bin/emacs
  '';

  buildInputs = [
    boost
    llvmPackages_5.llvm
    llvmPackages_5.clang
    llvmPackages_5.clang-unwrapped
    gmp
    emacs25-nox
    jre_headless
    tcl
    tk
  ];

  meta = {
    description = "An open source implementation of Oz 3.";
    maintainers = [ lib.maintainers.layus ];
    license = lib.licenses.bsd2;
    homepage = "https://mozart.github.io";
  };

}
