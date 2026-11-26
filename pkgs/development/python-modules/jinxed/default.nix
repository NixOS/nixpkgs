{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  blessed,
}:

buildPythonPackage (finalAttrs: {
  pname = "jinxed";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rockhopper-Technologies";
    repo = "jinxed";
    tag = finalAttrs.version;
    hash = "sha256-XnyB5gkTEBsfF7Spz6M0lDSiSL56krD8d3J5r2r4Gf0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "jinxed" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Jinxed Terminal Library";
    homepage = "https://github.com/Rockhopper-Technologies/jinxed";
    changelog = "https://github.com/Rockhopper-Technologies/jinxed/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      mpl20
    ];
    inherit (blessed.meta) maintainers;
  };
})
