{ stdenv, fetchurl, cmake, libdigidoc, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkgconfig, xsd, zlib, vim }:

stdenv.mkDerivation rec {

  version = "3.12.0.1317";
  name = "libdigidocpp-${version}";

  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/libd/libdigidocpp/libdigidocpp_3.12.0.1317.orig.tar.xz";
    sha256 = "8059e1dbab99f062d070b9da0b1334b7226f1ab9badcd7fddea3100519d1f9a9";
  };

  unpackPhase = ''
    mkdir src
    tar xf $src -C src
    cd src
  '';

  buildInputs = [ cmake libdigidoc minizip pcsclite opensc openssl xercesc
                  xml-security-c pkgconfig xsd zlib vim
                ];
  
  meta = with stdenv.lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
