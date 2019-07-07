{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, fusepy, fuse
, openssl }:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "4.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vqlmvk34jgvgx3qdsh50q7m4aiy02786jyjjcq45dcws7a4f9f1";
  };

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/monkey.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/test_module.py --replace '"openssl"' '"${openssl.bin}/bin/openssl"'
    substituteInPlace tests/monkey.py --replace /etc/ssl/openssl.cnf ${openssl.out}/etc/ssl/openssl.cnf
  '';

  buildInputs = [ setuptools_scm ];
  checkInputs = [ fusepy fuse ];

  doCheck = false; # seems to hang, not sure

  meta = with stdenv.lib; {
    description = "A tiny script to issue and renew TLS certs from Let's Encrypt";
    homepage = https://github.com/diafygi/acme-tiny;
    license = licenses.mit;
  };
}
