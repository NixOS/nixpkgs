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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hikari-crescent";
    repo = "hikari-crescent";
    tag = "v${version}";
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

  meta = with lib; {
    description = "A command handler for Hikari that keeps your project neat and tidy";
    license = licenses.mit;
    homepage = "https://github.com/hikari-crescent/hikari-crescent";
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "hikari-crescent";
  };
}
