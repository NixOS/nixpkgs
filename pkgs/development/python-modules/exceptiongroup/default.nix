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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    rev = version;
    hash = "sha256-XQcYYz4MOxWj9QlgM6KuwBaCHjYzGRkQw3cN5WBSnAo=";
  };

  nativeBuildInputs = [
    flit-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = if (pythonAtLeast "3.11") then [
    # regression in 3.11.4
    # https://github.com/agronholm/exceptiongroup/issues/64
    "test_catch_handler_raises"
  ] else null;

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
