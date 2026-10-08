{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "laundrify-aio";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laundrify";
    repo = "laundrify-pypi";
    tag = "v${version}";
    hash = "sha256-iFQ0396BkGWM7Ma/I0gbXucd2/yPmEVF4IC3/bMK2SA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "laundrify_aio" ];

  meta = {
    description = "Module to communicate with the laundrify API";
    homepage = "https://github.com/laundrify/laundrify-pypi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
