{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.5.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70b638cf4743f33042bebb3b51e25261a0a10e80f978739f17e7fd4837664a66";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
