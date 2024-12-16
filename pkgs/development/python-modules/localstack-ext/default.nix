{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  dill,
  dnslib,
  dnspython,
  plux,
  pyaes,
  pyotp,
  python-jose,
  requests,
  python-dateutil,
  tabulate,

  # Sensitive downstream dependencies
  localstack,
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "3.7.2";
  pyproject = true;

  src = fetchPypi {
    pname = "localstack_ext";
    inherit version;
    hash = "sha256-gd+HyZnezgtKrSKJOYtxUZHTPMrrpKWQHGvaIs9FyVs=";
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
    dill
    dnslib
    dnspython
    plux
    pyaes
    pyotp
    python-jose
    requests
    tabulate
    python-dateutil
  ] ++ python-jose.optional-dependencies.cryptography;

  pythonImportsCheck = [ "localstack" ];

  # No tests in repo
  doCheck = false;

  passthru.tests = {
    inherit localstack;
  };

  meta = {
    description = "Extensions for LocalStack";
    homepage = "https://github.com/localstack/localstack";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
