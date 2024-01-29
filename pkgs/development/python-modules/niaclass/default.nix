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
  pname = "niaclass";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukapecnik";
    repo = "NiaClass";
    rev = "refs/tags/${version}";
    hash = "sha256-md1e/cOIOQKoB760E5hjzjCsC5tS1CzgqAPTeVtrmuo=";
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

  # create scikit-learn dep version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaclass"
  ];

  meta = with lib; {
    description = "A framework for solving classification tasks using Nature-inspired algorithms";
    homepage = "https://github.com/lukapecnik/NiaClass";
    changelog = "https://github.com/lukapecnik/NiaClass/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

