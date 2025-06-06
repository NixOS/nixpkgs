{ lib, stdenv, fetchurl, xercesc }:

let
in
stdenv.mkDerivation rec {
  pname = "xsd";
  version = "4.0.0";

  src = fetchurl {
    url = "https://codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2";
    sha256 = "05wqhmd5cd4pdky8i8qysnh96d2h16ly8r73whmbxkajiyf2m9gc";
  };

  patches = [ ./xsdcxx.patch ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  buildFlags = [
    "LDFLAGS=-L${xercesc}/lib"
    "CPPFLAGS=-I${xercesc}/include"
  ];
  installFlags = buildFlags ++ [
    "install_prefix=${placeholder "out"}"
  ];

  buildInputs = [ xercesc ];

  meta = {
    homepage = "http://www.codesynthesis.com/products/xsd";
    description = "Open-source, cross-platform W3C XML Schema to C++ data binding compiler";
    mainProgram = "xsd";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jagajaga ];
  };
}
