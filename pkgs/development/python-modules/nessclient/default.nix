{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  justbackoff,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nessclient";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = "nessclient";
    tag = version;
    hash = "sha256-E4gkrhQzA1TDmjM+NPWl1Fyoagn/pLm7BRjGSpw6LXY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    justbackoff
    pyserial-asyncio-fast
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nessclient" ];

  meta = {
    description = "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    homepage = "https://github.com/nickw444/nessclient";
    changelog = "https://github.com/nickw444/nessclient/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ness-cli";
  };
}
