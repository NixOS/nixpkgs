{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  mkdocs,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "mkdocs-github-admonitions-plugin";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PGijsbers";
    repo = "admonitions";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fhnpgagYYLt4eCxNOlnMIjZknlmzkTEfuhIcPiGXCq4=";
  };

  build-system = [ hatchling ];

  dependencies = [ mkdocs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "admonitions" ];

  meta = {
    description = "Convert GitHub-style admonitions to `mkdocs-material`-style";
    homepage = "https://github.com/PGijsbers/admonitions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
    platforms = lib.platforms.all;
  };
})
