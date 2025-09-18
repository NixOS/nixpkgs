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
  version = "6.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = "midea-local";
    tag = "v${version}";
    hash = "sha256-jeQ5PXkKxVz041VJ58lJVpqIoj1Y054VADFtnutddg4=";
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

  meta = with lib; {
    description = "Control your Midea M-Smart appliances via local area network";
    homepage = "https://github.com/midea-lan/midea-local";
    changelog = "https://github.com/midea-lan/midea-local/releases/tag/${src.tag}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
