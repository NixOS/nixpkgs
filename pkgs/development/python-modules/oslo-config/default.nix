{ lib, buildPythonPackage, fetchPypi
, pbr, six, netaddr
, stevedore, mock
, debtcollector
, rfc3986
, pyyaml
, oslo-i18n
, bandit
, reno
, openstackdocstheme
, sphinx
, coverage
, oslotest
}:

buildPythonPackage rec {
  pname = "oslo.config";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1wcw1j8cz2rb0ihqidvnb47r7yh9vzaafw5l18fqr452s6wp70";
  };

  propagatedBuildInputs = [ pbr six netaddr stevedore debtcollector rfc3986 pyyaml oslo-i18n ];
  checkInputs = [ mock bandit reno openstackdocstheme sphinx coverage oslotest ];

  meta = with lib; {
    description = "Oslo Configuration API";
    homepage = "https://docs.openstack.org/oslo.config/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };


}
