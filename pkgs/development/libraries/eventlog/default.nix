{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "eventlog-0.2.12";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files/eventlog/0.2/eventlog_0.2.12.tar.gz";
    sha256 = "494dac8e01dc5ce323df2ad554d94874938dab51aa025987677b2bc6906a9c66";
  };

  meta = {
    description = "A new API to format and send structured log messages.";
    homepage = "http://www.balabit.com/support/community/products/";
    license = "BSD";
  };
}
