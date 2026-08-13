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
  version = "5.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ziys39Ao5lvSP/QD1lcuv6s7AG1tLd46qFwmNnWp+7U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    iso8601
    os-service-types
    requests
    stevedore
    typing-extensions
  ]
  # TODO: remove this workaround and fix breakages
  ++ lib.concatAttrValues optional-dependencies;

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "keystoneauth1" ];

  meta = {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://github.com/openstack/keystoneauth";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
