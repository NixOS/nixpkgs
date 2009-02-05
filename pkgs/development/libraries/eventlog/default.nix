{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "eventlog-0.2.9";
  src = fetchurl {
    url = "http://www.balabit.com/downloads/files/eventlog/0.2/eventlog_0.2.9.tar.gz";
    sha256 = "1cairmv47b66blrxwrgf4qwabfflak9b1dwkiyxnc9rj5svnq50m";
  };

  meta = {
    description = "A new API to format and send structured log messages.";
    homepage = "http://www.balabit.com/support/community/products/";
    license = "BSD";
  };
}
