{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pkgs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "5.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "acme_tiny";
    inherit version;
    hash = "sha256-LV64B+JZhq69qbBJ2dFG8YW6/q1u+x6MxB1rQrm8pjw=";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py tests/utils.py tests/test_module.py \
      --replace-fail '"openssl"' '"${lib.getExe pkgs.openssl}"'
    substituteInPlace tests/utils.py \
      --replace-fail /etc/ssl/openssl.cnf ${pkgs.openssl.out}/etc/ssl/openssl.cnf
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false; # fails to setup pebble

  preCheck = ''
    export ACME_TINY_PEBBLE_BIN=${lib.getExe pkgs.pebble}
    export ACME_TINY_DOMAIN=localhost
  '';

  pythonImportsCheck = [ "acme_tiny" ];

  meta = {
    description = "Tiny script to issue and renew TLS certs from Let's Encrypt";
    mainProgram = "acme-tiny";
    homepage = "https://github.com/diafygi/acme-tiny";
    license = lib.licenses.mit;
  };
}
