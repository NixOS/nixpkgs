{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pynintendoauth,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoparental";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoparental";
    tag = version;
    hash = "sha256-gq81cdI/HegNs1llQkC4GbEzHzvEs6f4MrBtIK/G2SE=";
  };

  postPatch = ''
    substituteInPlace pynintendoparental/_version.py \
      --replace-fail '__version__ = "0.0.0"' '__version__ = "${version}"'
  '';

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
