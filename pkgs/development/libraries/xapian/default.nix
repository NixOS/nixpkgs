{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.0.14";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.0.14/xapian-core-1.0.14.tar.gz;
    sha256 = "0d51p6210059dbf0vn6zh2iyg4i5pynmhyh0gphnph2b317a1dcx";
  };

  buildInputs = [zlib];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = "GPLv2";
  };
}
