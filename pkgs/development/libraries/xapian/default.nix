{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation rec {
  name = "xapian-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
    sha256 = "0xv4da5rmqqzkkkzx2v3jwh5hz5zxhd2b7m8x30fk99a25blyn0h";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ libuuid zlib ];

  meta = {
    description = "Search engine library";
    homepage = http://xapian.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.unix;
  };
}
