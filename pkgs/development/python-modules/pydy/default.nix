{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  sympy,
  setuptools,
  pytestCheckHook,
  cython,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydy";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wJ/mxocV12hssQqYKaSDZtLQbDEko/btDzCmXf1lJOo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cython
  ];

  pythonImportsCheck = [ "pydy" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
