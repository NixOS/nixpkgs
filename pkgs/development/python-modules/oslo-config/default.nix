{ lib, buildPythonPackage, fetchPypi
, debtcollector, netaddr, stevedore, oslo-i18n, rfc3986, pyyaml, requests, importlib-metadata }:

buildPythonPackage rec {
  pname = "oslo-config";
  version = "8.7.1";

  src = fetchPypi {
    inherit version;
    pname = "oslo.config";
    sha256 = "0q3v4yicqls9zsfxkmh5mrgz9dailaz3ir25p458gj6dg3bldhx0";
  };

  propagatedBuildInputs = [
    debtcollector
    netaddr
    stevedore
    oslo-i18n
    rfc3986
    pyyaml
    requests
    importlib-metadata
  ];

  # Tests have a circular dependency with oslo-log
  doCheck = false;
  pythonImportsCheck = [ "oslo_config" ];

  meta = with lib; {
    description = "Oslo Configuration API";
    homepage = "https://docs.openstack.org/oslo.config/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
