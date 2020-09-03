{ lib
, buildPythonPackage
, fetchPypi
, iso8601
, os-service-types
, pbr
, requests
, stevedore

, lxml
, oauthlib
, pyyaml
, requests-kerberos
, testresources
, testtools
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18c9khnk31i23x8mhvyrlh9gvhdphi3ac2p1f59d1wzg4z6bz5ll";
  };

  propagatedBuildInputs = [
    iso8601
    os-service-types
    pbr
    requests
    stevedore
  ];

  checkInputs = [
    oauthlib
    lxml
    requests-kerberos
    pyyaml
    testtools
    testresources
  ];

  # Circular dependencies on stestr, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Authentication Library for OpenStack Identity";
    license = licenses.asl20;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
