{stdenv, fetchurl, python, sip, qt4}:

stdenv.mkDerivation {
  name = "pyqt-x11-gpl-4.4.4";
  src = fetchurl {
    url = http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-x11-gpl-4.4.4.tar.gz;
    md5 = "4bd346d56d10452e47ac71e2cbe04229";
  };
  configurePhase = "python ./configure.py --confirm-license -b $out/bin -d $out/lib/python2.5/site-packages -v $out/share/sip -p $out/plugins";
  buildInputs = [ python sip qt4 ];
}
