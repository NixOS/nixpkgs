{
  lib,
  argparse-addons,
  bitstruct,
  buildPythonPackage,
  python-can,
  crccheck,
  diskcache,
  fetchPypi,
  matplotlib,
  parameterized,
  pytest-freezegun,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  textparser,
}:

buildPythonPackage (finalAttrs: {
  pname = "cantools";
  version = "41.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VRuYBZLGbmsSX4xF8Styb6hzUrKTG5AmsHY2o3dQSp4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argparse-addons
    bitstruct
    python-can
    crccheck
    diskcache
    textparser
  ];

  optional-dependencies.plot = [ matplotlib ];

  nativeCheckInputs = [
    parameterized
    pytest-freezegun
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.plot;

  pythonImportsCheck = [ "cantools" ];

  meta = {
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gray-heron ];
    mainProgram = "cantools";
  };
})
