{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "lark-oapi";
  version = "1.6.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "oapi-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFfg24TyCaGX+nu/HuD+UjHibdPMccn/X4V6SVdvO60=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    pycryptodome
    requests
    requests-toolbelt
    websockets
  ];

  # websockets 16.0 is compatible despite the <16 metadata constraint
  pythonRelaxDeps = [ "websockets" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lark_oapi" ];

  meta = {
    description = "Larksuite development interface SDK";
    homepage = "https://github.com/larksuite/oapi-sdk-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.knightfemale ];
  };
})
