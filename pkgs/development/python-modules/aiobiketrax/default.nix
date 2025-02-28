{
  lib,
  aiohttp,
  auth0-python,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiobiketrax";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = "aiobiketrax";
    tag = "v${version}";
    hash = "sha256-N0v5SCTf3NkW/TCSTQL9VkrDj7/GXEejJGFCvJY4pIc=";
  };

  postPatch = ''
    # https://github.com/basilfx/aiobiketrax/pull/63
    substituteInPlace aiobiketrax/api.py \
      --replace-fail "auth0.v3" "auth0"
  '';

  pythonRelaxDeps = [ "auth0-python" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    auth0-python
    python-dateutil
    pyjwt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiobiketrax" ];

  meta = with lib; {
    description = "Library for interacting with the PowUnity BikeTrax GPS tracker";
    homepage = "https://github.com/basilfx/aiobiketrax";
    changelog = "https://github.com/basilfx/aiobiketrax/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
