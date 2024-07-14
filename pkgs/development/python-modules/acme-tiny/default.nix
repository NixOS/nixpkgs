{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  fusepy,
  fuse,
  openssl,
}:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "5.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N4VJgI7s5XTDtdzqgrIWU0lJQj1cesJB2UGSEtZ2vI0=";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/test_module.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/utils.py --replace /etc/ssl/openssl.cnf ${openssl.out}/etc/ssl/openssl.cnf
  '';

  buildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    fusepy
    fuse
  ];

  doCheck = false; # seems to hang, not sure

  pythonImportsCheck = [ "acme_tiny" ];

  meta = with lib; {
    description = "Tiny script to issue and renew TLS certs from Let's Encrypt";
    mainProgram = "acme-tiny";
    homepage = "https://github.com/diafygi/acme-tiny";
    license = licenses.mit;
  };
}
