{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-shellitem";
  version = "3.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.shellitem";
    rev = "refs/tags/${version}";
    hash = "sha256-BL1eTxL82hjsGBRK5mBNxygEzQvjN8P6/tu6KOkHf9s=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.shellitem"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Shellitem structures";
    homepage = "https://github.com/fox-it/dissect.shellitem";
    changelog = "https://github.com/fox-it/dissect.shellitem/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
