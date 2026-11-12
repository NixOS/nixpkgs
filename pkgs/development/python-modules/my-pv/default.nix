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
  version = "0.0.17";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "my-PV";
    repo = "py-mypv";
    tag = finalAttrs.version;
    hash = "sha256-zpzVJRzmNkloY+ZVnaTWMruTJrK7ScdYObfdg7Uh/TQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.32.4" "hatchling"
  '';

  pythonRelaxDeps = [
    "aiohttp"
  ];

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
