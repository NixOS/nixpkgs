{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypck";
  version = "0.9.15a3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = "pypck";
    tag = finalAttrs.version;
    hash = "sha256-ep/D0MWHnmoorCYhWxlyd/iEBiSIrWL4aEPPn4uRgDI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_connection_lost" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pypck" ];

  meta = {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
