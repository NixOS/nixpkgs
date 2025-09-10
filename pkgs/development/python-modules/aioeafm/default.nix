{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioeafm";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aioeafm";
    tag = version;
    hash = "sha256-bL59EPvFd5vjay2sqBPGx+iL5sE/0n/EtR4K7obtDBE=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/Jc2k/aioeafm/pull/4
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/Jc2k/aioeafm/commit/549590e2ed465be40e2406416d89b8a8cd8c6185.patch";
      hash = "sha256-cG/vQI1XQO8LVvWsHrAj8KlPGRulvO7Ny+k0CKUpPqQ=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  doCheck = false; # Failed: async def functions are not natively supported.

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioeafm" ];

  meta = with lib; {
    description = "Python client for access the Real Time flood monitoring API";
    homepage = "https://github.com/Jc2k/aioeafm";
    changelog = "https://github.com/Jc2k/aioeafm/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
