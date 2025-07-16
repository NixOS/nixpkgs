{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cint";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZvAm0oxG756pY1vlyzQlBsahr4DRHLHIgaiJjKQp/JE=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "C-like underflow/overflow and automatic type conversion semantics for ctypes.c_* types";
    homepage = "https://github.com/disconnect3d/cint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ feyorsh ];
  };
}
