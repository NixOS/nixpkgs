{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, zlib
}:

buildPythonPackage rec {
  pname = "pybigwig";
  version = "0.3.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "pyBigWig";
    rev = "refs/tags/${version}";
    hash = "sha256-wJC5eXIC9PNlbCtmq671WuoIJVkh3aX7K6WArJWjyFg=";
  };

  buildInputs = [
    zlib
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyBigWig"
  ];

  pytestFlagsArray = [
    "pyBigWigTest/test*.py"
  ];

  disabledTests = [
    # Test file is donwloaded from GitHub
    "testAll"
    "testBigBed"
    "testFoo"
    "testNumpyValues"
  ];

  meta = with lib; {
    description = "File access to bigBed files, and read and write access to bigWig files";
    longDescription = ''
      A Python extension, written in C, for quick access to bigBed files
      and access to and creation of bigWig files. This extension uses
      libBigWig for local and remote file access.
    '';
    homepage = "https://github.com/deeptools/pyBigWig";
    changelog = "https://github.com/deeptools/pyBigWig/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
