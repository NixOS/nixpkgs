{ lib, buildPythonPackage, fetchPypi, setuptools-scm, fusepy, fuse
, openssl }:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7050b9428d45319e14ab9ea77f0ff4eb40451e5a68325d4c5358a87cff0e793";
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
