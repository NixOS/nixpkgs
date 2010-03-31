{stdenv, fetchurl, python, sip, qt4}:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.7.2";
  
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.7.2.tar.gz;
    sha256 = "097gxdr7jqv5a58z89djylm2b21x83crqn2fjsr5zmwhc0zwj5yv";
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
