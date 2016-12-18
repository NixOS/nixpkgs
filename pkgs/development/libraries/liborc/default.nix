{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "liborc-${version}";
  version = "0.4.26";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/o/orc/orc_${version}.orig.tar.xz";
    sha256 = "0jd69ynvr3k70mlxxgbsk047l1rd63m1wkj3qdcq7644xy0gllkx";
  };

  meta = with stdenv.lib; {
    homepage = https://packages.debian.org/wheezy/liborc-0.4-0;
    description = "Orc is a library and set of tools for compiling and executing very simple programs that operate on arrays of data.";
    license = with licenses; [ bsd2 bsd3 ];
  };
}
