{ stdenv, fetchurl, xalanc, xercesc, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xml-security-c-${version}";
  version = "1.7.3";

  src = fetchurl {
    url = "http://www.apache.org/dist/santuario/c-library/${name}.tar.gz";
    sha256 = "e5226e7319d44f6fd9147a13fb853f5c711b9e75bf60ec273a0ef8a190592583";
  };

  patchPhase = ''
    mkdir -p xsec/yes/lib
    sed -i -e 's/-O2 -DNDEBUG/-DNDEBUG/g' configure
  '';

  configurePhase = ''
    ./configure --prefix=$out \
                --with-openssl \
                --with-xerces \
                --with-xalan \
                --disable-static
  '';

  buildInputs = [ xalanc xercesc openssl pkgconfig ];

  meta = {
    homepage = http://santuario.apache.org/;
    description = "C++ Implementation of W3C security standards for XML";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
