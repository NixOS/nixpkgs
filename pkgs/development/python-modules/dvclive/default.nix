{ lib
, buildPythonPackage
, dvc-render
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-ditc4WWTEuO4ACqL87BNgjm1B6Aj6PPWrFX+OoF5jOI=";
  };

  propagatedBuildInputs = [
    dvc-render
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvclive"
  ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
