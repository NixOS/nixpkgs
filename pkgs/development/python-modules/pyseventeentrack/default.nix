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

buildPythonPackage (finalAttrs: {
  pname = "pyseventeentrack";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaiu";
    repo = "pyseventeentrack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6XNPKNyJERT75RfRuiQXG9gI+gQ2yFzmsdX+bmbRVns=";
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
    changelog = "https://github.com/shaiu/pyseventeentrack/releases/tag/v${finalAttrs.version}";
    description = "Simple Python API for 17track.net";
    homepage = "https://github.com/shaiu/pyseventeentrack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
