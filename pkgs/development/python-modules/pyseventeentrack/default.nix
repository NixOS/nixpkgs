{
  aiohttp,
  aresponses,
  attrs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyseventeentrack";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaiu";
    repo = "pyseventeentrack";
    tag = "v${version}";
    hash = "sha256-XFn9yZbUrvERBQW1PumwtAPHhcyRX9L+JKxE/NZjZys=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [
    aiohttp
    attrs
    cryptography
    pytz
  ];

  pythonImportsCheck = [ "pyseventeentrack" ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/shaiu/pyseventeentrack/releases/tag/v${version}";
    description = "Simple Python API for 17track.net";
    homepage = "https://github.com/shaiu/pyseventeentrack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
