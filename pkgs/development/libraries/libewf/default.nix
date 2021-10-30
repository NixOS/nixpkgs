{ fetchurl, lib, stdenv, zlib, openssl, libuuid, pkg-config }:

stdenv.mkDerivation rec {
  version = "20201230";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${version}/libewf-experimental-${version}.tar.gz";
    sha256 = "sha256-10r4jPzsA30nHQzjdg/VkwTG1PwOskwv8Bra34ZPMgc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.raskin ] ;
    platforms = lib.platforms.unix;
  };
}
