{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, numpy
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, scikit-learn
, toml-adapt
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "1.1.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukapecnik";
    repo = "NiaAML";
    rev = "refs/tags/${version}";
    hash = "sha256-GAUXEkUOD04DQtRG/RAeeeLmenBd25h18Lmrxbm4X3A=";
  };

  pythonRelaxDeps = [
    "pandas"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
    toml-adapt
  ];

  propagatedBuildInputs = [
    niapy
    numpy
    pandas
    scikit-learn
  ];

  # create scikit-learn and niapy deps version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
    toml-adapt -path pyproject.toml -a change -dep niapy -ver X
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaaml"
  ];

  meta = with lib; {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/lukapecnik/NiaAML";
    changelog = "https://github.com/lukapecnik/NiaAML/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
