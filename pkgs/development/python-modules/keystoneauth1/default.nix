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
  stestrCheckHook,
  stevedore,
  testresources,
  testtools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "5.17.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gjWazCDHVPyyKBjgkOL+pkfkxcETemrdtJhOn7pwirM=";
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
    stestrCheckHook
    testresources
    testtools
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "keystoneauth1" ];

  meta = {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://github.com/openstack/keystoneauth";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
