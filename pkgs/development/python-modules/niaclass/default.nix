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
  pname = "niaclass";
  version = "0.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lukapecnik";
    repo = "NiaClass";
    rev = "refs/tags/${version}";
    sha256 = "sha256-md1e/cOIOQKoB760E5hjzjCsC5tS1CzgqAPTeVtrmuo=";
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

  # create scikit-learn dep version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaclass"
  ];

  meta = with lib; {
    description = "A framework for solving classification tasks using Nature-inspired algorithms";
    homepage = "https://github.com/lukapecnik/NiaClass";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

