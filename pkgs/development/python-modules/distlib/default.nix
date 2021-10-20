{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = "https://distlib.readthedocs.io";
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

