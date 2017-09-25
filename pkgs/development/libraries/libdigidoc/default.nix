{ stdenv, fetchurl, cmake, openssl, pcsclite, opensc, libxml2 }:

stdenv.mkDerivation rec {

  version = "3.10.1.1212";
  name = "libdigidoc-${version}";
  
  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/libd/libdigidoc/libdigidoc_3.10.1.1212.orig.tar.xz";
    sha256 = "ad5e0603aea2e02977f17318cc93a53c3a19a815e57b2347d97136d11c110807";
  };

  unpackPhase = ''
    mkdir src
    tar xf $src -C src
    cd src
  '';

  buildInputs = [ cmake openssl pcsclite opensc libxml2 ];
  
  meta = with stdenv.lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
