{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyuptimerobot";
  version = "24.0.1";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pyuptimerobot";
    tag = version;
    hash = "sha256-vlEXUwGCmscasdWyCxF1bFjA3weR74Zf3RCk5W5ljFg=";
  };

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pyuptimerobot" ];

  meta = {
    description = "Python API wrapper for Uptime Robot";
    homepage = "https://github.com/ludeeus/pyuptimerobot";
    changelog = "https://github.com/ludeeus/pyuptimerobot/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
