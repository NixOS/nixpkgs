{ lib
, buildPythonPackage
, fetchPypi
, ddt
, installShellFiles
, openstackdocstheme
, osc-lib
, pbr
, python-cinderclient
, python-keystoneclient
, python-novaclient
, requests-mock
, sphinx
, stestr
}:

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c65e3d51018f193cce2daf3d0fd69daa36003bdb2b85df6b07b973e4c39e2f92";
  };

  nativeBuildInputs = [
    installShellFiles
    openstackdocstheme
    sphinx
  ];

  propagatedBuildInputs = [
    osc-lib
    pbr
    python-cinderclient
    python-keystoneclient
    python-novaclient
  ];

  postInstall = ''
    sphinx-build -a -E -d doc/build/doctrees -b man doc/source doc/build/man
    installManPage doc/build/man/openstack.1
  '';

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
