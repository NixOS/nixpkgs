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
  pname = "dissect-ntfs";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ntfs";
    rev = version;
    hash = "sha256-4QEsWTdqlHIP1a9g45+zv1SdHY0Ofsr7Rf1z+ctssSw=";
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

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.ntfs"
  ];

  disabledTestPaths = [
    # Test is very time consuming
    "tests/test_index.py"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the NTFS file system";
    homepage = "https://github.com/fox-it/dissect.ntfs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
