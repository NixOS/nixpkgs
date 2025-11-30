{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  fusepy,
  fuse,
  openssl,
}:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "5.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "acme_tiny";
    inherit version;
    hash = "sha256-s84ZVYPcLxOnxvqQBS+Ks0myMtvCZ62cv0co6u2E3dg=";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace-fail '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/test_module.py --replace-fail '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/utils.py --replace-fail /etc/ssl/openssl.cnf ${openssl.out}/etc/ssl/openssl.cnf
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    fusepy
    fuse
  ];

  pythonImportsCheck = [ "acme_tiny" ];

  meta = {
    description = "Tiny script to issue and renew TLS certs from Let's Encrypt";
    mainProgram = "acme-tiny";
    homepage = "https://github.com/diafygi/acme-tiny";
    license = lib.licenses.mit;
  };
}
