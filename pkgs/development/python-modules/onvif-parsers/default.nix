{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  onvif-zeep-async,
  zeep,
  pytest-cov-stub,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "onvif-parsers";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvideolibs";
    repo = "onvif-parsers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gFbyzQ7GUjFDjp2Pbnc3FzQLu35kXjmTD8H2g3nY4KE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    onvif-zeep-async
    zeep
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "onvif_parsers" ];

  meta = {
    description = "Parsers for ONVIF events";
    homepage = "https://github.com/openvideolibs/onvif-parsers";
    changelog = "https://github.com/openvideolibs/onvif-parsers/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
