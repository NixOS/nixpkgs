{ lib
, fetchFromGitHub
, fetchurl
, cmake
, unzip
, makeWrapper
, boost169
, pinnedBoost ? boost169
, llvmPackages
, gmp
, emacs
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

  patches = [ ./patch-limits.diff ];

  postConfigure = ''
    cp ${bootcompiler} bootcompiler/bootcompiler.jar
  '';

  nativeBuildInputs = [ cmake makeWrapper unzip ];

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DMOZART_BOOST_USE_STATIC_LIBS=OFF"
    # We are building with clang, as nix does not support having clang and
    # gcc together as compilers and we need clang for the sources generation.
    # However, clang emits tons of warnings about gcc's atomic-base library.
    "-DCMAKE_CXX_FLAGS=-Wno-braced-scalar-init"
  ];

  fixupPhase = ''
    wrapProgram $out/bin/oz --set OZEMACS ${emacs}/bin/emacs
  '';

  buildInputs = [
    pinnedBoost
    gmp
    emacs
    jre_headless
    tcl
    tk
  ];

  meta = with lib; {
    description = "An open source implementation of Oz 3";
    maintainers = with maintainers; [ layus h7x4 ];
    license = licenses.bsd2;
    homepage = "https://mozart.github.io";
  };

}
