{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  chardet,
  pytestCheckHook,
  faker,
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "mbstrdecoder";
    tag = "v${version}";
    hash = "sha256-rJ3Q7/xYPO0jBuzhYm2aIhPar2tbJIxHnHR0y0HWtik=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ faker ];

  meta = {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "Library for decoding multi-byte character strings";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
