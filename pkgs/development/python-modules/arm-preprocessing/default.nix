{ lib
, buildPythonPackage
, fetchFromGitHub
, niaarm
, pandas
, poetry-core
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, scikit-learn
}:

buildPythonPackage rec {
  pname = "arm-preprocessing";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "arm-preprocessing";
    rev = "refs/tags/${version}";
    hash = "sha256-svB/gdc5tj3Qkk8NR9nnkmnBjzF6REBvjoYHfrWBYoQ=";
  };

  pythonRelaxDeps = [
    "niaarm"
    "pandas"
    "scikit-learn"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    niaarm
    pandas
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arm_preprocessing"
  ];

  meta = with lib; {
    description = "Implementation of several preprocessing techniques for association rule mining";
    homepage = "https://github.com/firefly-cpp/arm-preprocessing";
    changelog = "https://github.com/firefly-cpp/arm-preprocessing/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
