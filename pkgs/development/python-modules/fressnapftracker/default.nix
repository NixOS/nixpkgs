{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pydantic,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "fressnapftracker";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "fressnapftracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ZsK/yW+E4nwP5S300FPXnfPe11fIL2ULII2SkhLAys=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ hatchling ];

  dependencies = [
    httpx
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "fressnapftracker" ];

  meta = {
    description = "Asynchronous Python client for the Fressnapf Tracker GPS API";
    homepage = "https://github.com/eifinger/fressnapftracker";
    changelog = "https://github.com/eifinger/fressnapftracker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
