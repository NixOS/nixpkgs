{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "my-pv";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "my-PV";
    repo = "py-mypv";
    tag = finalAttrs.version;
    hash = "sha256-qzVm5L9C5dlaZA45kbrEGxWGDqFmM5HljU3b+YDk7C0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "my_pv" ];

  meta = {
    description = "Library to interface with my-PV devices";
    homepage = "https://github.com/my-PV/py-mypv";
    changelog = "https://github.com/my-PV/py-mypv/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
