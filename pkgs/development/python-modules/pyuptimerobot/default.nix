{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyuptimerobot";
  version = "24.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pyuptimerobot";
    tag = version;
    hash = "sha256-vlEXUwGCmscasdWyCxF1bFjA3weR74Zf3RCk5W5ljFg=";
  };

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",'
  '';

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pyuptimerobot" ];

  meta = {
    description = "Python API wrapper for Uptime Robot";
    homepage = "https://github.com/ludeeus/pyuptimerobot";
    changelog = "https://github.com/ludeeus/pyuptimerobot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
