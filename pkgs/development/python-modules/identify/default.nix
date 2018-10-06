{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e956558a9a1e3b3891d7c6609fc9709657a11878af288ace484d1a46a93922b";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
