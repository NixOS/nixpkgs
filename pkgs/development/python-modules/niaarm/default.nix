{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, nltk
, numpy
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.3.8";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    rev = "refs/tags/${version}";
    hash = "sha256-p07SuCl433rj6IEMO1eg5QHAUTVfgqYo5gsprMvQg2Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    niapy
    nltk
    numpy
    pandas
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaarm"
  ];

  meta = with lib; {
    description = "A minimalistic framework for Numerical Association Rule Mining";
    mainProgram = "niaarm";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
