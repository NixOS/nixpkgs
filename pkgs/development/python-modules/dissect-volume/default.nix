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
  pname = "dissect-volume";
  version = "3.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.volume";
    rev = "refs/tags/${version}";
    hash = "sha256-hEfURO4ITpjSpfHMlYfzO1cG+tjvqBP5QLYzo2uz8yo=";
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
    "dissect.volume"
  ];

  disabledTests = [
    # gzip.BadGzipFile: Not a gzipped file
    "test_ddf_read"
    "test_dm_thin"
    "test_lvm_mirro"
    "test_lvm_thin"
    "test_md_raid0_zones"
    "test_md_read"
  ];

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.volume";
    changelog = "https://github.com/fox-it/dissect.volume/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
