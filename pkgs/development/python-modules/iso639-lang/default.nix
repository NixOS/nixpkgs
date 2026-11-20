{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iso639-lang";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LBeaudoux";
    repo = "iso639";
    tag = "v${version}";
    hash = "sha256-ORqSrf84b/ddpCUi9e43ur6C+XcJjQGM+fmJ8e/wFus=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iso639" ];

  meta = {
    description = "Fast, comprehensive ISO 639 library for individual languages and language groups";
    homepage = "https://github.com/LBeaudoux/iso639";
    changelog = "https://github.com/LBeaudoux/iso639/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
