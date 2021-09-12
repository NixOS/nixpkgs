{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, oslo-config
, oslo-context
, oslo-serialization
, oslo-utils
, oslotest
, pbr
, pyinotify
, python-dateutil
, stestr
}:

buildPythonPackage rec {
  pname = "oslo-log";
  version = "4.6.0";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    sha256 = "dad5d7ff1290f01132b356d36a1bb79f98a3929d5005cce73e849ed31b385ba7";
  };

  propagatedBuildInputs = [
    oslo-config
    oslo-context
    oslo-serialization
    oslo-utils
    pbr
    python-dateutil
  ] ++ lib.optionals stdenv.isLinux [
    pyinotify
  ];

  checkInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_log" ];

  meta = with lib; {
    description = "oslo.log library";
    homepage = "https://github.com/openstack/oslo.log";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
