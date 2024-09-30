{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  justbackoff,
  pyserial-asyncio,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nessclient";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = "nessclient";
    rev = "refs/tags/${version}";
    hash = "sha256-STDEIY7D02MlH+R6uLAKl6ghSQjhG1OEQWj71DrZP30=";
  };

  build-system = [ setuptools ];

  dependencies = [
    justbackoff
    pyserial-asyncio
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nessclient" ];

  meta = with lib; {
    description = "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    homepage = "https://github.com/nickw444/nessclient";
    changelog = "https://github.com/nickw444/nessclient/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ness-cli";
  };
}
