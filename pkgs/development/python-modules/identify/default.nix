{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "443f419ca6160773cbaf22dbb302b1e436a386f23129dbb5482b68a147c2eca9";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
