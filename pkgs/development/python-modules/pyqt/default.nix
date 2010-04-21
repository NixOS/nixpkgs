{stdenv, fetchurl, python, sip, qt4}:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.7.3";
  
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.7.3.tar.gz;
    sha256 = "0p12m2rjsm3igpqqmgn79my2h16vhxq8dma9ih1744hpnirdcjjp";
  };
  
  configurePhase = "python ./configure.py --confirm-license -b $out/bin -d $out/lib/${python.libPrefix}/site-packages -v $out/share/sip -p $out/plugins";
  
  buildInputs = [ python sip qt4 ];
  
  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
