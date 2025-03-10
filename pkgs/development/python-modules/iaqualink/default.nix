{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "iaqualink";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    rev = "v${version}";
    hash = "sha256-ewPP2Xq+ecZGc5kokvLEsRokGqTWlymrzkwk480tapk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "iaqualink" ];

  meta = with lib; {
    description = "Python library for Jandy iAqualink";
    homepage = "https://github.com/flz/iaqualink-py";
    changelog = "https://github.com/flz/iaqualink-py/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
