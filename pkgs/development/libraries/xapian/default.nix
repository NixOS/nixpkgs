{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation rec {
  name = "xapian-${version}";
  version = "1.2.21";

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
    sha256 = "0grd2s6gf8yzqwdaa50g57j9d81mxkrrpkyldm2shgyizdc8gx33";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ libuuid zlib ];

  meta = {
    description = "Search engine library";
    homepage = http://xapian.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
