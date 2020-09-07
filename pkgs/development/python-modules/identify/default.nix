{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f5fcf22b665eaece583bd395b103c2769772a0f646ffabb5b1f155901b07de2";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
  };
}
