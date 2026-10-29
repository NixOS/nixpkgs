{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  cython,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyworld";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeremyCCHsu";
    repo = "Python-Wrapper-for-World-Vocoder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FK/SNt6OOYWWv6fVX29J4WBvaQ4jjR45SI95igORrj0=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "pyworld" ];

  __structuredAttrs = true;

  meta = {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
})
