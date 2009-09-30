{stdenv, fetchurl, lib, python, sip, qt4}:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.6";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.6.tar.gz;
    sha256 = "0an7fadypsz4wyrss4f6ysb6gjgl3ygrchx94vbnc146jpfy7p19";
  };
  configurePhase = "python ./configure.py --confirm-license -b $out/bin -d $out/lib/python2.5/site-packages -v $out/share/sip -p $out/plugins";
  buildInputs = [ python sip qt4 ];
  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.mesaPlatforms;
  };
}
