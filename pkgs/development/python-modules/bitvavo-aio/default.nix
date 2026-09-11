{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bitvavo-aio";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "bitvavo-aio";
    tag = finalAttrs.version;
    hash = "sha256-L64stPpprLN8kCePc08VcciimtDQ6QFkj9P2s/daNrU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "bitvavo" ];

  meta = {
    description = "Python client for Bitvavo crypto exchange API";
    homepage = "https://github.com/cyberjunky/bitvavo-aio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
