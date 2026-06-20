{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoauth";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoauth";
    tag = version;
    hash = "sha256-1GCeFaHHdU98ar6QLwyBI7Smzlj5XvyqPhC7Ev8uvmE=";
  };

  postPatch = ''
    substituteInPlace pynintendoauth/_version.py \
      --replace-fail '__version__ = "1.0.0"' '__version__ = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pynintendoauth" ];

  # upstream has no unit tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pynintendoauth/releases/tag/${src.tag}";
    description = "Python module to provide APIs to authenticate with Nintendo services";
    homepage = "https://github.com/pantherale0/pynintendoauth";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
