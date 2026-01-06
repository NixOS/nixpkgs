{
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysenz";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nordicopen";
    repo = "pysenz";
    tag = "v${version}";
    hash = "sha256-gS9dsGQ8waOlUbHWHiJbQrvh4RdFb4SNEH4J4TbT2x8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    authlib
    httpx
  ];

  pythonImportsCheck = [ "pysenz" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/nordicopen/pysenz/releases/tag/${src.tag}";
    description = "Async Typed Python package for the Chemelex (nVent) RAYCHEM SENZ RestAPI";
    homepage = "https://github.com/nordicopen/pysenz";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
