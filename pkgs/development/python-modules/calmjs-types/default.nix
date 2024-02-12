{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "calmjs-types";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "calmjs.types";
    inherit version;
    sha256 = "sha256-EGWYv9mx3RPqs9dnB5t3Bu3hiujL2y/XxyMP7JkjjAQ=";
    extension = "zip";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "calmjs.types" ];

  meta = with lib; {
    description = "Types for the calmjs framework";
    homepage = "https://github.com/calmjs/calmjs.types";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
