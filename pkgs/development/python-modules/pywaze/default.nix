{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "pywaze";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    rev = "refs/tags/v${version}";
    hash = "sha256-fShfnfYhUtthwHSFYIFj2cWE9dZXakTrfqiR3AL2nb8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov --cov-report term-missing --cov=src/pywaze " ""
  '';

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pywaze" ];

  meta = with lib; {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
