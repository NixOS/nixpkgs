{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "log4c";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/log4c/${pname}-${version}.tar.gz";
    sha256 = "1sj8xpgfmw7ncxf91a8as3avapdxynxzdysjm07w8b7mj80h54ar";
  };

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A logging framework for C patterned after Apache log4j";
    longDescription = ''
      Log4c is a library of C for flexible logging to files, syslog and other
      destinations. It is modeled after the Log for Java library .
    '';
    homepage = "http://log4c.sourceforge.net/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.wucke13 ];
    platforms = platforms.unix;
  };
}
