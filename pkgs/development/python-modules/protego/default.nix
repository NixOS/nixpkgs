{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "protego";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "protego";
    tag = version;
    hash = "sha256-2vyETqRYeof5CzOCXCGUYb5vSyV/eT5+lm2GNWiuaF0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "protego" ];

  meta = with lib; {
    description = "Module to parse robots.txt files with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    changelog = "https://github.com/scrapy/protego/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
