{
  black,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blacken-docs";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "blacken-docs";
    rev = version;
    hash = "sha256-3FGuFOAHCcybPwujWlh58NWtuF5CebaKTgBWgCGpSL8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    black
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/adamchainz/blacken-docs";
    changelog = "https://github.com/adamchainz/blacken-docs/blob/${src.rev}/CHANGELOG.rst";
    description = "Run Black on Python code blocks in documentation files";
    license = licenses.mit;
    maintainers = with maintainers; [ l0b0 ];
    mainProgram = "blacken-docs";
  };
}
