{ lib, buildPythonPackage, fetchPypi, flask, ldapdomaindump, pycryptodomex, pyasn1, pyopenssl, chardet }:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.9.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "113isxb9rd2n761nnh3skg3vqa0v5dalz9kbavyczqyv1jjyh6qw";
  };

  propagatedBuildInputs = [ flask ldapdomaindump pycryptodomex pyasn1 pyopenssl chardet ];

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
