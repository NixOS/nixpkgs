{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "priority";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yWXVTxuNDQsZR52zkkx8Ns9nLb8q7JLUP72vRJK6GMA=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "priority" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Pure-Python implementation of the HTTP/2 priority tree";
    homepage = "https://github.com/python-hyper/priority/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss ];
  };
})
