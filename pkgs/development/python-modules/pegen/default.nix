{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pegen";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "we-like-parsers";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5nxOMgkDAkHtVFSNXf0SPoag6/E7b97eVnFoAqyJE3g=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pegen"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/we-like-parsers/pegen/issues/89
    "test_invalid_def_stmt"
  ];

  meta = with lib; {
    description = "Library to generate PEG parsers";
    homepage = "https://github.com/we-like-parsers/pegen";
    changelog = "https://github.com/we-like-parsers/pegen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
