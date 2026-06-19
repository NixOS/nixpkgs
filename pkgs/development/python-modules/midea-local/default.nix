{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiofiles,
  aiohttp,
  colorlog,
  commonregex,
  defusedxml,
  deprecated,
  ifaddr,
  pycryptodome,
  platformdirs,
}:

buildPythonPackage rec {
  pname = "midea-local";
  version = "6.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = "midea-local";
    tag = "v${version}";
    hash = "sha256-AKZuRmTtQ+V9m/rN9P0kKm0kkcrrX2eKDYpYwb5Djf4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    colorlog
    commonregex
    defusedxml
    deprecated
    ifaddr
    pycryptodome
    platformdirs
  ];

  meta = {
    description = "Control your Midea M-Smart appliances via local area network";
    homepage = "https://github.com/midea-lan/midea-local";
    changelog = "https://github.com/midea-lan/midea-local/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ k900 ];
    license = lib.licenses.mit;
  };
}
