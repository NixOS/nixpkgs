{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-fat";
  version = "3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fat";
    rev = version;
    hash = "sha256-GBeacQtNA1onh67Svqo5R43gap/Lzpm+20TXcUMmU5k=";
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

  # dissect.fat.exceptions.InvalidBPB: Invalid BS_jmpBoot
  doCheck = false;

  pythonImportsCheck = [
    "dissect.fat"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the FAT file system";
    homepage = "https://github.com/fox-it/dissect.fat";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
