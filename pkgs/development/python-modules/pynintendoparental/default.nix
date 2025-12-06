{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pynintendoauth,
  python-dotenv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoparental";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoparental";
    tag = version;
    hash = "sha256-LtIMWh4igyrZ5WQQ9ylv6NRrHAJdGq0FONw4SdH0hYI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pynintendoauth
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
