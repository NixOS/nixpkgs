{
  lib,
  buildPythonPackage,
  fetchPypi,
  netaddr,
  oslo-concurrency,
  oslo-config,
  oslo-serialization,
  oslo-utils,
  prettytable,
  requests,
  setuptools,
  webob,
}:

buildPythonPackage rec {
  pname = "osprofiler";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d6jaKyO7X5BIBUvVzMRdCshFdMqKiO8SC4+sbohk4kw=";
  };

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

  # NOTE(vinetos): OSProfiler depends on jeager-client which use opentracing
  # Opentracing and jeager-client are archived since 2022.
  # As this package is made only to support old OpenStack clients and bindings,
  # We do not really care
  doCheck = false;

  pythonImportsCheck = [ "osprofiler" ];

  meta = with lib; {
    description = "OpenStack Library to profile request between all involved services";
    homepage = "https://opendev.org/openstack/osprofiler/";
    license = licenses.asl20;
    mainProgram = "osprofiler";
    teams = [ teams.openstack ];
  };
}
