{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f44e637caa40d1b4cb37f6ed3b262ede74901d28b1cc5b1fc07360871edd65d";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
