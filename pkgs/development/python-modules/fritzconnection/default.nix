{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  segno,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fritzconnection";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kbr";
    repo = "fritzconnection";
    tag = finalAttrs.version;
    hash = "sha256-J07zAXZxQc3TCfsjYcBhQdxsYwHabE9vdj3eMkWua54=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  optional-dependencies = {
    qr = [ segno ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "fritzconnection" ];

  disabledTestPaths = [
    # Functional tests require network access
    "fritzconnection/tests/test_functional.py"
  ];

  meta = {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${finalAttrs.src.tag}/sources/version_history.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      valodim
    ];
  };
})
