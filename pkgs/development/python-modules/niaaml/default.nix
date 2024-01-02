{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, numpy
, pandas
, poetry-core
, scikit-learn
, toml-adapt
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "1.1.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lukapecnik";
    repo = "NiaAML";
    rev = version;
    hash = "sha256-GAUXEkUOD04DQtRG/RAeeeLmenBd25h18Lmrxbm4X3A=";
  };

  nativeBuildInputs = [
    poetry-core
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
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
