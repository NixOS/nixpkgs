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
  pname = "dissect-extfs";
  version = "3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.extfs";
    rev = "refs/tags/${version}";
    hash = "sha256-yM9PTMI4/8oU2bvOCKdh5tT0gw9+6esV1auKSbupL0U=";
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
    "dissect.extfs"
  ];

  # Archive files seems to be corrupt
  doCheck = false;

  meta = with lib; {
    description = "Dissect module implementing a parser for the ExtFS file system";
    homepage = "https://github.com/fox-it/dissect.extfs";
    changelog = "https://github.com/fox-it/dissect.extfs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
