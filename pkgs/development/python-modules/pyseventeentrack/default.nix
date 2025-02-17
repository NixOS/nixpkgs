{
  aiohttp,
  aresponses,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyseventeentrack";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaiu";
    repo = "pyseventeentrack";
    tag = "v${version}";
    hash = "sha256-B/p+7wuXMtdOlIOySGQdtiiErcVD8DaVJPvSX4lPnos=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    attrs
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
