{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python-dotenv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoparental";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoparental";
    tag = version;
    hash = "sha256-mH34BcbK3qyB2sAmVyAQz6GhI+xWAdRHagZzLVI9gr8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pynintendoparental" ];

  # test.py connects to the actual API
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pynintendoparental/releases/tag/${src.tag}";
    description = "Python module to interact with Nintendo Parental Controls";
    homepage = "https://github.com/pantherale0/pynintendoparental";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
