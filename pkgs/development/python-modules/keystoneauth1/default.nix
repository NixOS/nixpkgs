{
  lib,
  buildPythonPackage,
  fetchPypi,
  betamax,
  hacking,
  iso8601,
  lxml,
  oauthlib,
  os-service-types,
  oslo-config,
  oslo-utils,
  pbr,
  pycodestyle,
  pyyaml,
  requests,
  requests-kerberos,
  requests-mock,
  setuptools,
  six,
  stestr,
  stevedore,
  testresources,
  testtools,
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "5.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sswtaNGkjpwsbZsbH9ANfHvf4IboBAtR5wk4qLo639E=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  nativeCheckInputs = [
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

  # test_keystoneauth_betamax_fixture is incompatible with urllib3 2.0.0
  # https://bugs.launchpad.net/keystoneauth/+bug/2020112
  checkPhase = ''
    stestr run \
      -E "keystoneauth1.tests.unit.test_betamax_fixture.TestBetamaxFixture.test_keystoneauth_betamax_fixture"
  '';

  pythonImportsCheck = [ "keystoneauth1" ];

  meta = with lib; {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://github.com/openstack/keystoneauth";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
