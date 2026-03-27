{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pynintendoauth,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynintendoparental";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoparental";
    tag = finalAttrs.version;
    hash = "sha256-2qcupx+x578E+n+YsmB81XrVE5M0QFZPP82H5KxEkss=";
  };

  postPatch = ''
    substituteInPlace pynintendoparental/_version.py \
      --replace-fail '__version__ = "0.0.0"' '__version__ = "${finalAttrs.version}"'
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
    changelog = "https://github.com/pantherale0/pynintendoparental/releases/tag/${finalAttrs.src.tag}";
    description = "Python module to interact with Nintendo Parental Controls";
    homepage = "https://github.com/pantherale0/pynintendoparental";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
