args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/p/python-qt3/python-qt3_3.17.4.orig.tar.gz;
    sha256 = "0p76g64ww9nhg1sahphanwb7nkjmsvxyaqk8k8iaycnlc8040c8r";
  };

  buildInputs = [qt python pkgconfig pythonSip libX11 libXext glib];
  configureFlags = [" -q ${qt} "];

  /* doConfigure should be specified separately */
  phaseNames = ["doPythonConfigure" "doMakeInstall"];
  extraPythonConfigureCommand = ''echo yes | \'';

  name = "python-qt-" + version;
  meta = {
    description = "Qt bindings for Python";
    license = "GPL";
  };
}
