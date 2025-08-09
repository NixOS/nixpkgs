{
  lib,
  buildPythonPackage,
  cachetools,
  fetchPypi,
  nixosTests,
  setuptools,
  twisted,
  txamqp,
  urllib3,
  whisper,
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wTtbqRHMWBcM2iFN95yzwCf/BQ+EK0vp5MXT4mKX3lw=";
  };

  patches = [
    # imp has been removed from python since version 3.12
    # This patch replaces it with distutils.utils
    ./replace-imp.patch
  ];

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular Python module.
  GRAPHITE_NO_PREFIX = "True";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "cf.readfp(f, 'setup.cfg')" "cf.read(f, 'setup.cfg')"
  '';

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    twisted
    txamqp
    urllib3
    whisper
  ];

  # Tests are not shipped with PyPI
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) graphite;
  };

  pythonImportsCheck = [
    "carbon"
    "carbon.routers"
  ];

  meta = {
    description = "Backend data caching and persistence daemon for Graphite";
    homepage = "https://github.com/graphite-project/carbon";
    changelog = "https://github.com/graphite-project/carbon/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      basvandijk
    ];
  };
}
