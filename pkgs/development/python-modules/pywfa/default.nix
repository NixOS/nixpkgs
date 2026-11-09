{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  wheel,
  pysam,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pywfa";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kcleal";
    repo = "pywfa";
    tag = "v${version}";
    hash = "sha256-TeJ7Jq4LR+I1+zeMeBtHZa9dR+CRJJG5sT99tB227P8=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pysam
    unittestCheckHook
  ];

  preCheck = ''
    cd pywfa/tests
  '';

  pythonImportsCheck = [
    "pywfa"
    "pywfa.align"
  ];

  meta = {
    description = "Python wrapper for wavefront alignment using WFA2-lib";
    homepage = "https://github.com/kcleal/pywfa";
    changelog = "https://github.com/kcleal/pywfa/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
