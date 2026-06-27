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
  version = "3.2.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "autopxd2";
    inherit version;
    hash = "sha256-Zf44gmkuWvp8lfrScq4GAhOisLYu4scyuNp1Cn3lnVc=";
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

  # real_headers tests download headers at runtime
  # libclang tests need clang2 python module
  pytestFlags = [
    "-m"
    "not real_headers and not libclang"
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
