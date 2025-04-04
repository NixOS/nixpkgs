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
  version = "5.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_serialization";
    inherit version;
    hash = "sha256-vcTT3Ze4BjmzUF5G2apDn8lQKIFBd/MLkXQ+gTZsO+c=";
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

  meta = with lib; {
    description = "Oslo Serialization library";
    homepage = "https://github.com/openstack/oslo.serialization";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
