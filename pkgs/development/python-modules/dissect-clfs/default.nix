{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-clfs";
  version = "1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.clfs";
    tag = version;
    hash = "sha256-IwiE7sikZ2Rqg8GS0DKLbV/ENcRPTm0eAS3xvVG0gLw=";
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
