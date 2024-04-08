{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-scm
, pytestCheckHook
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    rev = version;
    hash = "sha256-iGeaRVJeFAWfJpwr7N4kST7d8YxpX3WgDqQemlR0cLU=";
  };

  nativeBuildInputs = [
    flit-scm
  ];

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "exceptiongroup"
  ];

  meta = with lib; {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
