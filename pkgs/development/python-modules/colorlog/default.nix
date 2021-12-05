{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NE9zIEAJ5Mg8W2vrALPEXccPza48gNuRngpBcdAG/eg=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorlog" ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
