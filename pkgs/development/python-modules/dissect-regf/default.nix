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
  pname = "dissect-regf";
  version = "3.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.regf";
    rev = "refs/tags/${version}";
    hash = "sha256-NLhZnStcJCtXMBkayLjvuG7aK2aN3sWGZaPKVXIoRew=";
  };

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
    "dissect.regf"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Windows registry file format";
    homepage = "https://github.com/fox-it/dissect.regf";
    changelog = "https://github.com/fox-it/dissect.regf/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
