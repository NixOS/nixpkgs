{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-regf";
  version = "3.12";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.regf";
    tag = version;
    hash = "sha256-ONE8dX2AHSboDzSFQ+7ZkIqVmQW3J8QyeOr8ZKrlvqI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.regf" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Windows registry file format";
    homepage = "https://github.com/fox-it/dissect.regf";
    changelog = "https://github.com/fox-it/dissect.regf/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
