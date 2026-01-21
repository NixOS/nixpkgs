{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "protego";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "protego";
    tag = version;
    hash = "sha256-70/DPap3FgLfh4ldYSve5Pt8o7gM1lME/OmRFaew/38=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "protego" ];

  meta = {
    description = "Module to parse robots.txt files with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    changelog = "https://github.com/scrapy/protego/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
