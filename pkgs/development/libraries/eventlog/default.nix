{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "eventlog-0.2.12";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files/eventlog/0.2/eventlog_0.2.12.tar.gz";
    sha256 = "494dac8e01dc5ce323df2ad554d94874938dab51aa025987677b2bc6906a9c66";
  };

  meta = {
    description = "Syslog event logger library";
    longDescription = ''
      The EventLog library aims to be a replacement of the simple syslog() API
      provided on UNIX systems. The major difference between EventLog and
      syslog is that EventLog tries to add structure to messages.

      Where you had a simple non-structrured string in syslog() you have a
      combination of description and tag/value pairs.
    '';
    homepage = http://www.balabit.com/support/community/products/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
