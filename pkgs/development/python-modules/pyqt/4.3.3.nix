args : with args;

rec {
  src = fetchurl {
    url = mirror://debian/pool/main/p/python-qt4/python-qt4_4.3.3.orig.tar.gz;
    sha256 = "0m8yzaz17nb8prm2kmy0mbiq4np515abi2xkadflsgwq1bj86qyk";
  };

  buildInputs = [qt python pkgconfig pythonSip libX11 libXext glib];
  configureFlags = [" -p $prefix/share/pyQt4/plugins " '' -e "$prefix/include/python$pythonVersion" ''];

  /* doConfigure should be specified separately */
  phaseNames = ["doPythonConfigure" "doMakeInstall"];
  extraPythonConfigureCommand = ''echo yes | \'';

  name = "python-qt-4.3.3";
  meta = {
    description = "Qt bindings for Python";
    license = "GPL";
  };
}
