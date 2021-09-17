{ lib
, buildPythonPackage
, fetchPypi
, betamax
, hacking
, iso8601
, lxml
, oauthlib
, os-service-types
, oslo-config
, oslo-utils
, pbr
, pycodestyle
, pyyaml
, requests
, requests-kerberos
, requests-mock
, six
, stestr
, stevedore
, testresources
, testtools
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93605430a6d1424f31659bc5685e9dc1be9a6254e88c99f00cffc0a60c648a64";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [
    betamax
    iso8601
    lxml
    oauthlib
    os-service-types
    pbr
    requests
    requests-kerberos
    six
    stevedore
  ];

  checkInputs = [
    hacking
    oslo-config
    oslo-utils
    pycodestyle
    pyyaml
    requests-mock
    stestr
    testresources
    testtools
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "keystoneauth1" ];

  meta = with lib; {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://github.com/openstack/keystoneauth";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
