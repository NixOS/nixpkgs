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
  pynacl
}:

buildPythonPackage rec {
  pname = "hikari-crescent";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hikari-crescent";
    repo = "hikari-crescent";
    rev = "refs/tags/v${version}";
    hash = "sha256-0eDPdN+3lalgHiBNXuZUEJllAKFxdKK6paTFNHU5jIM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    hikari
    sigparse
  ];

  postPatch = ''
    # pythonRelaxDepsHook did not work
    substituteInPlace pyproject.toml \
      --replace-fail 'hikari = "==' 'hikari = ">='
  '';

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
    description = "A command handler for Hikari that keeps your project neat and tidy";
    license = lib.licenses.mit;
    homepage = "https://github.com/hikari-crescent/hikari-crescent";
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "hikari-crescent";
  };
}
