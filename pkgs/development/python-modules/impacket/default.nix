{ lib, buildPythonPackage, fetchPypi, flask, ldapdomaindump, pycryptodomex, pyasn1, pyopenssl, chardet, setuptools }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18d557d387f4914fafa739813b9172bc3f8bd9c036e93bf589a8e0ebb7304bba";
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
