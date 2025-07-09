{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  mkdocs,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "mkdocs-github-admonitions-plugin";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PGijsbers";
    repo = "admonitions";
    rev = "v${version}";
    hash = "sha256-fhnpgagYYLt4eCxNOlnMIjZknlmzkTEfuhIcPiGXCq4=";
  };

  build-system = [ hatchling ];

  dependencies = [ mkdocs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "admonitions" ];

  meta = {
    description = "Plugin to convert GitHub-style admonitions to `mkdocs-material`-style admonitions";
    homepage = "https://github.com/PGijsbers/admonitions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
}
