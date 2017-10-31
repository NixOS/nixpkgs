{ stdenv, fetchurl, xercesc }:

let
  fixed_paths = ''LDFLAGS="-L${xercesc}/lib" CPPFLAGS="-I${xercesc}/include"'';
in
stdenv.mkDerivation rec {
  name = "xsd-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "http://codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2";
    sha256 = "05wqhmd5cd4pdky8i8qysnh96d2h16ly8r73whmbxkajiyf2m9gc";
  };

  patches = [ ./xsdcxx.patch ];

  configurePhase = ''
    patchShebangs .
  '';

  buildPhase = ''
    make ${fixed_paths}
  '';

  buildInputs = [ xercesc ];

  installPhase = ''
    make ${fixed_paths} install_prefix="$out" install
  '';

  meta = {
    homepage = http://www.codesynthesis.com/products/xsd;
    description = "An open-source, cross-platform W3C XML Schema to C++ data binding compiler";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
