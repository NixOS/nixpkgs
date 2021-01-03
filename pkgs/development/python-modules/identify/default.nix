{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2c71bf9f5c482c389cef816f3a15f1c9d7429ad70f497d4a2e522442d80c6de";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
