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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaiu";
    repo = "pyseventeentrack";
    rev = "refs/tags/v${version}";
    hash = "sha256-AHFJu2z3UWBR6BzwdxAKl3wpqBnsyj8pn16z1rgFVpw=";
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
