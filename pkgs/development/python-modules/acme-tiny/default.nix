{ lib, buildPythonPackage, fetchPypi, setuptools-scm, fusepy, fuse
, openssl }:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jmg525n4n98hwy3hf303jbnq23z79sqwgliji9j7qcnph47gkgq";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/monkey.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/test_module.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/monkey.py --replace /etc/ssl/openssl.cnf ${openssl.out}/etc/ssl/openssl.cnf
  '';

  buildInputs = [ setuptools-scm ];
  checkInputs = [ fusepy fuse ];

  doCheck = false; # seems to hang, not sure

  meta = with lib; {
    description = "A tiny script to issue and renew TLS certs from Let's Encrypt";
    homepage = "https://github.com/diafygi/acme-tiny";
    license = licenses.mit;
  };
}
