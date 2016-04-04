{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation rec {
  name = "xapian-${version}";
  version = "1.2.23";

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
    sha256 = "0z9lhvfaazzmd611bnii9a0d19sqnjs0s9vbcgjhcv8s9spax0wp";
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
