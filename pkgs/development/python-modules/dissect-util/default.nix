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
  version = "3.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    tag = version;
    hash = "sha256-dHP5nyumuQxAS3hkw4XRaLR3DMFn+WEFkLRbKBODIFo=";
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

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.util";
    changelog = "https://github.com/fox-it/dissect.util/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dump-nskeyedarchiver";
  };
}
