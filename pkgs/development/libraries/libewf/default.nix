{ fetchurl, lib, stdenv, zlib, openssl, libuuid, pkg-config }:

stdenv.mkDerivation rec {
  version = "20201129";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${version}/libewf-experimental-${version}.tar.gz";
    sha256 = "168k1az9hm0lajh57zlbknsq5m8civ1rzp81zz4sd7v64xilzxdk";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.raskin ] ;
    platforms = lib.platforms.unix;
    inherit version;
  };
}
