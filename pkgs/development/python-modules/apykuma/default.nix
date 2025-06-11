{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "apykuma";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "apykuma";
    tag = "v${version}";
    hash = "sha256-Dxlyi0syoq+sfgjMLWHhpeKhDFgpfQrp18DJeBjrAEg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiohttp
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "apykuma"
  ];

  meta = {
    description = "Small library to notify Uptime Kuma that the service is up";
    homepage = "https://github.com/PerchunPak/apykuma";
    changelog = "https://github.com/PerchunPak/apykuma/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
  };
}
