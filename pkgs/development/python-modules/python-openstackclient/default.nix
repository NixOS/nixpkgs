{ lib
, buildPythonPackage
, fetchPypi
, ddt
, osc-lib
, pbr
, python-cinderclient
, python-keystoneclient
, python-novaclient
, requests-mock
, stestr
}:

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0abc6666378c5a7db83ec83515a8524fb6246a919236110169cc5c216ac997ea";
  };

  propagatedBuildInputs = [
    osc-lib
    pbr
    python-cinderclient
    python-keystoneclient
    python-novaclient
  ];

  checkInputs = [
    ddt
    stestr
    requests-mock
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "openstackclient" ];

  meta = with lib; {
    description = "OpenStack Command-line Client";
    homepage = "https://github.com/openstack/python-openstackclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
