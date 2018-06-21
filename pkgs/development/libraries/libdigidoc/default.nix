{ stdenv, fetchurl, cmake, openssl, pcsclite, opensc, libxml2 }:

stdenv.mkDerivation rec {

  version = "3.10.4.1218";
  name = "libdigidoc-${version}";
  
  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/libd/libdigidoc/libdigidoc_3.10.4.1218.orig.tar.xz";
    sha256 = "0nq9z7sq2f6f8h8scirh2djafzb44l37p6h87nvs4a92yv1z4pjr";
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
