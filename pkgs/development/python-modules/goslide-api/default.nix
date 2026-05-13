{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "goslide-api";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ualex73";
    repo = "goslide-api";
    tag = version;
    hash = "sha256-Z3+GijoI+351zV7IpLSBQu6LE2OhhXho4ygNMVbg2xs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "goslideapi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python API to utilise the Slide Open Cloud and Local API";
    homepage = "https://github.com/ualex73/goslide-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
