{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "protego";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "protego";
    tag = finalAttrs.version;
    hash = "sha256-qyOY35gNFojewFMFVT58k1s5uM4j9IZzEURnPh+3htE=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "protego" ];

  meta = {
    description = "Module to parse robots.txt files with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    changelog = "https://github.com/scrapy/protego/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
