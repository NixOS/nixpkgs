{
  lib,
  buildPythonPackage,
  fetchPypi,
  twisted,
  whisper,
  txamqp,
  cachetools,
  urllib3,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wTtbqRHMWBcM2iFN95yzwCf/BQ+EK0vp5MXT4mKX3lw=";
  };

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular python module.
  GRAPHITE_NO_PREFIX = "True";

  propagatedBuildInputs = [
    twisted
    whisper
    txamqp
    cachetools
    urllib3
  ];

  passthru.tests = {
    inherit (nixosTests) graphite;
  };

  meta = with lib; {
    homepage = "http://graphiteapp.org/";
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [
      offline
      basvandijk
    ];
    license = licenses.asl20;
  };
}
