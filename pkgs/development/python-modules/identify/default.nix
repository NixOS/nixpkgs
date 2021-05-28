{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c22c384a2c9b32c5cc891d13f923f6b2653aa83e2d75d8f79be240d6c86c4f4";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
