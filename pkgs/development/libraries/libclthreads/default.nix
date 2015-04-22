{ stdenv, fetchurl, }:

stdenv.mkDerivation rec {
  name = "libclthreads-${version}";
  version = "2.4.0";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/clthreads-${version}.tar.bz2";
    sha256 = "1s8xx99z6llv46cvkllmd72v2pkzbfl5gngcql85mf14mxkdb7x6";
  };

  configurePhase = ''
    sed -e "s@/usr/local@$out@" -i Makefile
    sed -e "s@/usr/bin/install@install@" -i Makefile
    sed -e "s@/sbin/ldconfig@ldconfig@" -i Makefile
    sed -e "s@SUFFIX :=.*@SUFFIX =@" -i Makefile
  '';

  meta = {
    description = "zita thread library";
    version = "${version}";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
