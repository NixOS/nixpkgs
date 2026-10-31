{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

buildPythonPackage (finalAttrs: {
  pname = "keystoneauth1";
  version = "5.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "keystoneauth";
    tag = finalAttrs.version;
    hash = "sha256-a9A7tz8l+onST/PJsYCZpiI0WRtJtD4cUf6TazE+Bi0=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include keystoneauth1 *" > MANIFEST.in
  '';

  build-system = [ setuptools ];

  dependencies = [
    iso8601
    os-service-types
    requests
    stevedore
    typing-extensions
  ]
  # TODO: remove this workaround and fix breakages
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  optional-dependencies = {
    betamax = [
      betamax
      pyyaml
    ];
    kerberos = [ requests-kerberos ];
    oauth1 = [ oauthlib ];
    saml2 = [ lxml ];
  };

  __darwinAllowLocalNetworking = true;

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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "keystoneauth1"
    "keystoneauth1.exceptions"
  ];

  meta = {
    description = "Authentication Library for OpenStack Identity";
    homepage = "https://github.com/openstack/keystoneauth";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
