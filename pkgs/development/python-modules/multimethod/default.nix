{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
}:
buildPythonPackage rec {
  pname = "multimethod";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed78cd3237c59652b226d571209d934860b99240c62935a706a9b3d0bce6ebb3";
  };

  checkInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "multimethod"
  ];

  meta = with lib; {
    description = "Multiple argument dispatching";
    homepage = "https://github.com/coady/multimethod";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
