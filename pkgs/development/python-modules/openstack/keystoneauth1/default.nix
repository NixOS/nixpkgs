{ lib, buildPythonApplication, pythonOlder, fetchPypi
, pbr, iso8601, requests, six, stevedore, openstack-os-service-types
}:

buildPythonApplication rec {
  pname = "openstack-keystoneauth1";
  version = "4.3.1";

  src = fetchPypi {
    pname = "keystoneauth1";
    inherit version;
    sha256 = "93605430a6d1424f31659bc5685e9dc1be9a6254e88c99f00cffc0a60c648a64";
  };

  propagatedBuildInputs = [
    pbr
    iso8601
    requests
    six
    stevedore
    openstack-os-service-types
  ];

  doCheck = false;

  pythonImportsCheck = [ "keystoneauth1" ];

  meta = with lib; {
    description = "Tools for authenticating to an OpenStack-based cloud";
    downloadPage = "https://pypi.org/project/keystoneauth/";
    homepage = "https://github.com/openstack/keystoneauth";
    changelog = "https://docs.openstack.org/releasenotes/keystoneauth/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
