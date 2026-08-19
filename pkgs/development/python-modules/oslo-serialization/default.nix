{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  oslo-utils,
  oslotest,
  pbr,
  setuptools,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-serialization";
  version = "5.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_serialization";
    inherit version;
    hash = "sha256-gyboWoCFbBBoAHQj/Pb+Kd0v5Xoy9dh//wEgtVW0tnw=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    msgpack
    oslo-utils
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_serialization" ];

  meta = {
    description = "Oslo Serialization library";
    homepage = "https://github.com/openstack/oslo.serialization";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
