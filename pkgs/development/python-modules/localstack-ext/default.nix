{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  click,
  dill,
  dnslib,
  dnspython,
  plux,
  pyaes,
  pyjwt,
  pyotp,
  python-dateutil,
  python-jose,
  pyyaml,
  requests,
  rich,
  tabulate,
  semver,

  # use for testing promoted localstack
  pkgs,
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "4.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "localstack_ext";
    inherit version;
    hash = "sha256-AQrG6iRTBarinrGgJeLr5OYguuN7KWyxRUYNMHz4mlE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRemoveDeps = [
    # Avoid circular dependency
    "localstack"
    "build"
  ];

  dependencies = [
    click
    dill
    dnslib
    dnspython
    plux
    pyaes
    pyjwt
    pyotp
    python-dateutil
    python-jose
    pyyaml
    requests
    rich
    tabulate
    semver
  ]
  ++ python-jose.optional-dependencies.cryptography;

  pythonImportsCheck = [ "localstack" ];

  # No tests in repo
  doCheck = false;

  passthru.tests = {
    inherit (pkgs) localstack;
  };

  meta = {
    description = "Extensions for LocalStack";
    homepage = "https://github.com/localstack/localstack";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
