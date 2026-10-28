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
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "mbstrdecoder";
    tag = "v${version}";
    hash = "sha256-RPtxoI4fFiBHBOWOdGueVjPPOAUjDThawS80SIoTQ78=";
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
