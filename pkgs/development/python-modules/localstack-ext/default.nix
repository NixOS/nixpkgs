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

  # use for testing promoted localstack
  pkgs,
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "localstack_ext";
    inherit version;
    hash = "sha256-PEsIes+CdYIhSPEy2J1u+kfzNIzbgQnKfwxw2oAmFYA=";
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
    inherit (pkgs) localstack;
  };

  meta = {
    description = "Extensions for LocalStack";
    homepage = "https://github.com/localstack/localstack";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
