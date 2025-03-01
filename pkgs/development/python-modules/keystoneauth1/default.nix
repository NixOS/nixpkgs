{
  lib,
  buildPythonPackage,
  fetchPypi,
  betamax,
  fixtures,
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
  stestr,
  stevedore,
  testresources,
  testtools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "5.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NLhw27z4Bs21rsmEg7YoIKZWjTZOynsRdMpqi1qcd+0=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      iso8601
      os-service-types
      pbr
      requests
      stevedore
      typing-extensions
    ]
    # TODO: remove this workaround and fix breakages
    ++ lib.flatten (builtins.attrValues optional-dependencies);

  optional-dependencies = {
    betamax = [
      betamax
      pyyaml
    ];
    kerberos = [ requests-kerberos ];
    oauth1 = [ oauthlib ];
    saml2 = [ lxml ];
  };

  nativeCheckInputs = [
    fixtures
    hacking
    oslo-config
    oslo-utils
    pycodestyle
    requests-mock
    stestr
    testresources
    testtools
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
