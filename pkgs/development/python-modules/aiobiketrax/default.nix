{ lib
, aiohttp
, auth0-python
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyjwt
, pytest-aiohttp
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "aiobiketrax";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lMgD315movmr+u+8BMaqhb1L46Wf0Ak56VAT2jpg1kM=";
  };

  postPatch = ''
    # https://github.com/basilfx/aiobiketrax/pull/63
    substituteInPlace aiobiketrax/api.py \
      --replace "auth0.v3" "auth0"
  '';

  pythonRelaxDeps = [
    "auth0-python"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    auth0-python
    python-dateutil
    pyjwt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiobiketrax"
  ];

  meta = with lib; {
    description = "Library for interacting with the PowUnity BikeTrax GPS tracker";
    homepage = "https://github.com/basilfx/aiobiketrax";
    changelog = "https://github.com/basilfx/aiobiketrax/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
