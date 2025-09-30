{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  pycparser,
  click,
  pytestCheckHook,
  cython,
}:

buildPythonPackage rec {
  pname = "python-autopxd2";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "autopxd2";
    inherit version;
    hash = "sha256-uxVWz2LSXWpDYvQFrxlrmxA1XQagyHTfFf4hhaHKOqc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pycparser
    click
    cython
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "test/"
  ];

  meta = {
    homepage = "https://github.com/elijahr/python-autopxd2";
    mainProgram = "autopxd";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    description = "Generates .pxd files automatically from .h files";
  };
}
