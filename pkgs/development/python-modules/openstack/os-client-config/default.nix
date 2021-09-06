{ lib, buildPythonApplication, fetchPypi
, openstack-sdk
}:

buildPythonApplication rec {
  pname = "openstack-os-client-config";
  version = "2.1.0";

  src = fetchPypi {
    pname = "os-client-config";
    inherit version;
    sha256 = "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e";
  };

  propagatedBuildInputs = [
    openstack-sdk
  ];

  doCheck = false;

  pythonImportsCheck = [ "os_client_config" ];

  meta = with lib; {
    description = "OpenStack Client Configuation Library";
    downloadPage = "https://pypi.org/project/os-client-config/";
    homepage = "https://github.com/openstack/os-client-config/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
