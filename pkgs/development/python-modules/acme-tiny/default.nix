{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, fusepy
, fuse
, openssl
}:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "5.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "378549808eece574c3b5dcea82b216534949423d5c7ac241d9419212d676bc8d";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/test_module.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/utils.py --replace /etc/ssl/openssl.cnf ${openssl.out}/etc/ssl/openssl.cnf
  '';

  buildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ fusepy fuse ];

  doCheck = false; # seems to hang, not sure

  pythonImportsCheck = [ "acme_tiny" ];

  meta = with lib; {
    description = "A tiny script to issue and renew TLS certs from Let's Encrypt";
    homepage = "https://github.com/diafygi/acme-tiny";
    license = licenses.mit;
  };
}
