{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "068zqb3w7nyqiv2hpy0zcpz2xd6xwhq5chigqrp9h9zav7bpr5sp";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = https://distlib.readthedocs.io;
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

