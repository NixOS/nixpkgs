{ lib, buildPythonApplication, fetchPypi
, openstack-debtcollector, netaddr, stevedore, openstack-oslo_i18n, rfc3986, pyyaml, requests, importlib-metadata
}:

buildPythonApplication rec {
  pname = "oslo_config";
  version = "8.7.1";

  src = fetchPypi {
    pname = "oslo.config";
    inherit version;
    sha256 = "a0c346d778cdc8870ab945e438bea251b5f45fae05d6d99dfe4953cca2277b60";
  };

  propagatedBuildInputs = [
    openstack-debtcollector
    netaddr
    stevedore
    openstack-oslo_i18n
    rfc3986
    pyyaml
    requests
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_config" ];

  meta = with lib; {
    description = "The Oslo configuration API supports parsing command line arguments and .ini style configuration files";
    downloadPage = "https://pypi.org/project/oslo.config/";
    homepage = "https://github.com/openstack/oslo.config";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
