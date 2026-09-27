{
  buildPythonPackage,
  dukpy,
  fetchFromGitHub,
  lib,
  pyobjc-framework-SystemConfiguration,
  publicsuffixlist,
  pytestCheckHook,
  requests,
  setuptools,
  stdenv,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypac";
  version = "0.19.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "carsonyl";
    repo = "pypac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GOqLeZgyvXXXbz9raLhhmgFfmd4zDPvA/R8kG2lBp9Y=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    dukpy
    publicsuffixlist
    requests
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ pyobjc-framework-SystemConfiguration ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require DNS lookups.
    "test_isResolvable"
    "test_isInNet"
    "test_dnsResolve"
    "test_dnsResolveEx"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires a resolvable local hostname.
    "test_myIpAddress"
  ];

  pythonImportsCheck = [ "pypac" ];

  meta = {
    description = "Proxy auto-config and auto-discovery for Python";
    homepage = "https://github.com/carsonyl/pypac";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ attila ];
  };
})
