{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-util";
  version = "3.23";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    tag = version;
    hash = "sha256-dHP5nyumuQxAS3hkw4XRaLR3DMFn+WEFkLRbKBODIFo=";
  };

  nativeBuildInputs = [
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
    mainProgram = "dump-nskeyedarchiver";
    homepage = "https://github.com/fox-it/dissect.util";
    changelog = "https://github.com/fox-it/dissect.util/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
