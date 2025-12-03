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
  version = "0.3.24";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "pyBigWig";
    tag = version;
    hash = "sha256-gK3cOwbvQtf+g1H/4x69swqCFdkBwpV7ZOrbE0eANh0=";
  };

  buildInputs = [ zlib ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyBigWig" ];

  enabledTestPaths = [ "pyBigWigTest/test*.py" ];

  disabledTests = [
    # Test file is downloaded from GitHub
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
    changelog = "https://github.com/deeptools/pyBigWig/releases/tag/${src.tag}";
    license = licenses.mit;
  };
}
