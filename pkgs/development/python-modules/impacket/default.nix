{ lib, buildPythonPackage, fetchPypi, flask, ldapdomaindump, pycryptodomex, pyasn1, pyopenssl, chardet, setuptools }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c1be8a50cdbe3cffc566ba64f552b1b28bcc79b7a406b833956b49c56d77184";
  };

  propagatedBuildInputs = [ flask ldapdomaindump pycryptodomex pyasn1 pyopenssl chardet setuptools ];

  # fail with:
  # RecursionError: maximum recursion depth exceeded
  doCheck = false;
  pythonImportsCheck = [ "impacket" ];

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
