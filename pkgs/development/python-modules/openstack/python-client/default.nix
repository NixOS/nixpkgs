{ lib, fetchFromGitHub, buildPythonApplication
, pbr, cliff, iso8601, openstack-sdk, openstack-osc-lib, openstack-oslo_i18n, openstack-oslo_utils, openstack-python-keystoneclient, openstack-python-novaclient, openstack-python-cinderclient, stevedore
}:

buildPythonApplication rec {
  pname = "openstack-client";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-openstackclient";
    rev = version;
    sha256 = "126bs3p5968cvjr8d4p57b69kd2cgqmqnnbkdpq5da1k8bx6m37x";
  };

  PBR_VERSION = version;

  propagatedBuildInputs = [
    pbr
    cliff
    iso8601
    openstack-sdk
    openstack-osc-lib
    openstack-oslo_i18n
    openstack-oslo_utils
    openstack-python-keystoneclient
    openstack-python-novaclient
    openstack-python-cinderclient
    stevedore
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/openstack --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "openstackclient" ];

  meta = with lib; {
    description = "A command-line client for OpenStack.";
    downloadPage = "https://github.com/openstack/python-openstackclient";
    homepage = "https://docs.openstack.org/python-openstackclient/latest/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ superherointj ];
  };
}
