{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-clfs";
  version = "1.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.clfs";
    tag = version;
    hash = "sha256-rw2LuCgn/oUnvf2HNXv00pDaiLrqjC5L57a1k62U6zU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ dissect-cstruct ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.clfs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the CLFS (Common Log File System) file system";
    homepage = "https://github.com/fox-it/dissect.clfs";
    changelog = "https://github.com/fox-it/dissect.clfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
