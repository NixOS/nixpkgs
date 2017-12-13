{ lib, fetchPypi, buildPythonPackage
# buildInputs
, keystoneauth1
, stevedore
, oslo-utils
, oslo-log
, oslo-i18n
, oslo-context
, oslo-config
, barbicanclient
, cryptography
, Babel
, pbr
# checkInputs
, coverage
, subunit
, sphinx
, openstackdocstheme
, oslotest
, testrepository
, testscenarios
, testtools
, bandit
, reno
# , pifpaf
}:

buildPythonPackage rec {
  pname = "castellan";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08xa2k85jv77pnfgr0islhasd4bscivm8bdxi1gr81qxw35qyqmf";
  };

  propagatedBuildInputs = [
    keystoneauth1
    stevedore
    oslo-utils
    oslo-log
    oslo-i18n
    oslo-context
    oslo-config
    barbicanclient
    cryptography
    Babel
    pbr
  ];

  checkInputs = [
    coverage
    subunit
    sphinx
    openstackdocstheme
    oslotest
    testrepository
    testscenarios
    testtools
    bandit
    reno
    # pifpaf
  ];

  meta = with lib; {
    description = "Generic Key Manager interface for OpenStack";
    homepage = "https://docs.openstack.org/castellan/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
