{ stdenv, fetchurl, cmake, libdigidoc, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkgconfig, xsd, zlib, vim }:

stdenv.mkDerivation rec {

  version = "3.13.3.1365";
  name = "libdigidocpp-${version}";

  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/libd/libdigidocpp/libdigidocpp_3.13.3.1365.orig.tar.xz";
    sha256 = "1xmvjh5xzspm6ja8hz6bzblwly7yn2jni2m6kx8ny9g65zjrj2iw";
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
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
