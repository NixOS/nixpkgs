{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoauth";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoauth";
    tag = version;
    hash = "sha256-8lyIf4T74Z3jhUL7AKSePsDmSVylmIgQ//pZYgYJBdw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pynintendoauth" ];

  # test.py connects to the actual API
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pynintendoauth/releases/tag/${src.tag}";
    description = "Python module to provide APIs to authenticate with Nintendo services";
    homepage = "https://github.com/pantherale0/pynintendoauth";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
