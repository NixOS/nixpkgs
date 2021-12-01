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
  version = "4.6.1";

  src = fetchPypi {
    pname = "oslo.log";
    inherit version;
    sha256 = "0dlnxjci9mpwhgfv19fy1z7xrdp8m95skrj5dr60all3pr7n22f6";
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
