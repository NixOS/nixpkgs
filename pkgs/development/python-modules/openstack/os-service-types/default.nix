{ lib, buildPythonApplication, pythonOlder, fetchPypi
, pbr
}:

buildPythonApplication rec {
  pname = "openstack-os-service-types";
  version = "1.7.0";

  src = fetchPypi {
    pname = "os-service-types";
    inherit version;
    sha256 = "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c";
  };

  propagatedBuildInputs = [
    pbr
  ];

  doCheck = false;

  pythonImportsCheck = [ "os_service_types" ];

  meta = with lib; {
    description = "Python library for consuming OpenStack sevice-types-authority data";
    downloadPage = "https://pypi.org/project/os-service-types/";
    homepage = "https://github.com/openstack/os-service-types";
    changelog = "https://docs.openstack.org/releasenotes/os-service-types/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
