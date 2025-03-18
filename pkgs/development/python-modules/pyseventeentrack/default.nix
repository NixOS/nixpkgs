{
  aiohttp,
  aresponses,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  lib,
  poetry-core,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pyseventeentrack";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaiu";
    repo = "pyseventeentrack";
    rev = "refs/tags/v${version}";
    hash = "sha256-J5pYtJrEvShRXE/NwbYdmcUhCc5dmDZmJWS550NvRD0=";
  };

  patches = [
    # https://github.com/shaiu/pyseventeentrack/pull/4
    (fetchpatch2 {
      name = "use-poetry-core.patch";
      url = "https://github.com/shaiu/pyseventeentrack/commit/6feef4fb29544933836de0a9c06bf85e5105c8bf.patch";
      hash = "sha256-l6lHWRAoRhYouNT43nb7fYA4RMsmC6rCJOKYTJN8vAU=";
    })
  ];

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
