{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libESMTP-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "http://brianstafford.info/libesmtp/libesmtp-1.0.6.tar.bz2";
    sha256 = "02zbniyz7qys1jmx3ghx21kxmns1wc3hmv80gp7ag7yra9f1m9nh";
  };

  meta = with stdenv.lib; {
    homepage = http://brianstafford.info/libesmtp/index.html;
    description = "A Library for Posting Electronic Mail";
    license = licenses.lgpl21;
  };
}

