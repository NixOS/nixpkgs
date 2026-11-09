{
  lib,
  buildPythonPackage,
  ddt,
  docutils,
  elasticsearch,
  fetchFromGitHub,
  netaddr,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  oslo-concurrency,
  oslo-config,
  oslo-serialization,
  oslo-utils,
  prettytable,
  pymongo,
  redis,
  requests,
  setuptools,
  stestrCheckHook,
  webob,
}:

buildPythonPackage (finalAttrs: {
  pname = "osprofiler";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osprofiler";
    tag = finalAttrs.version;
    hash = "sha256-igWYNdGusfEPagzmmoh0lnO1bHn63loxGXm76UVWJZs=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include osprofiler *" > MANIFEST.in
  '';

  build-system = [ setuptools ];

  dependencies = [
    netaddr
    oslo-concurrency
    oslo-config
    oslo-serialization
    oslo-utils
    prettytable
    requests
    webob
  ];

  nativeCheckInputs = [
    ddt
    docutils
    elasticsearch
    opentelemetry-exporter-otlp
    opentelemetry-sdk
    pymongo
    redis
    stestrCheckHook
  ];

  pythonImportsCheck = [
    "osprofiler"
    "osprofiler.drivers"
  ];

  meta = {
    description = "OpenStack Library to profile request between all involved services";
    homepage = "https://opendev.org/openstack/osprofiler/";
    license = lib.licenses.asl20;
    mainProgram = "osprofiler";
    teams = [ lib.teams.openstack ];
  };
})
