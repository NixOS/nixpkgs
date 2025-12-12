{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  hikari,
  sigparse,
  pytestCheckHook,
  python-dotenv,
  pytest-asyncio,
  croniter,
  pynacl,
}:

buildPythonPackage rec {
  pname = "hikari-crescent";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hikari-crescent";
    repo = "hikari-crescent";
    tag = "v${version}";
    hash = "sha256-86NCAlN5/JGrxPVIMs6ARr6H4G3shPcgxASwukptyJo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    hikari
    sigparse
  ];

  pythonImportsCheck = [ "crescent" ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dotenv
    pytest-asyncio
    croniter
    pynacl
  ];

  disabledTests = [ "test_handle_resp" ];

  meta = {
    description = "Command handler for Hikari that keeps your project neat and tidy";
    license = lib.licenses.mit;
    homepage = "https://github.com/hikari-crescent/hikari-crescent";
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "hikari-crescent";
  };
}
