{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
  zlib,
}:

buildPythonPackage rec {
  pname = "pybigwig";
  version = "0.3.23";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "pyBigWig";
    rev = "refs/tags/${version}";
    hash = "sha256-ch9nZrQAnzFQQ62/NF4J51pV4DQAbVq4/f/6LaXf5hM=";
  };

  buildInputs = [ zlib ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyBigWig" ];

  pytestFlagsArray = [ "pyBigWigTest/test*.py" ];

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
