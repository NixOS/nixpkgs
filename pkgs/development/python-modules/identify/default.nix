{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0749c74180ef0f6a3874eaa0bf89a6990a523233180e83e6f3c7c27312ac9ba3";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
