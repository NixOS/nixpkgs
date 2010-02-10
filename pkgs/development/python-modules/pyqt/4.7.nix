{stdenv, fetchurl, lib, python, sip, qt4}:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.7";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.7.tar.gz;
    sha256 = "0hwp84igw639mgw344q2jmnjarhq5wk60ncn8h2jjg7k4vchbvkz";
  };
  configurePhase = "python ./configure.py --confirm-license -b $out/bin -d $out/lib/${python.libPrefix}/site-packages -v $out/share/sip -p $out/plugins";
  buildInputs = [ python sip qt4 ];
  meta = {
    description = "Python bindings for Qt";
    license = "GPL";
    homepage = http://www.riverbankcomputing.co.uk;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.mesaPlatforms;
  };
}
