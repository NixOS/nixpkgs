{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-util";
  version = "3.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    tag = version;
    hash = "sha256-AbkIVtUbQkkui7H1ZT/xHl1tCfZMvlrbZ2RD3YJAh0E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.util" ];

  disabledTests = [
    # File handling issue
    "test_cpio_formats"
  ];

  meta = {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.util";
    changelog = "https://github.com/fox-it/dissect.util/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dump-nskeyedarchiver";
  };
}
