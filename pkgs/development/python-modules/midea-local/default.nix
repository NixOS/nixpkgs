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
  version = "6.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Q0ua0cIYfZ60RzrRNatx+a1nz1f51rR2D5IS5abXKME=";
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
    description = " Control your Midea M-Smart appliances via local area network";
    homepage = "https://github.com/midea-lan/midea-local";
    changelog = "https://github.com/midea-lan/midea-local/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
