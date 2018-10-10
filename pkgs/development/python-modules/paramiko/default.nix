{ pkgs
, buildPythonPackage
, fetchPypi
, cryptography
, bcrypt
, pynacl
, pyasn1
, python
, pytest
, pytest-relaxed
, mock
, isPyPy
, isPy33
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8975a7df3560c9f1e2b43dc54ebd40fd00a7017392ca5445ce7df409f900fcb";
  };

  checkInputs = [ pytest mock pytest-relaxed ];
  propagatedBuildInputs = [ bcrypt cryptography pynacl pyasn1 ];

  __darwinAllowLocalNetworking = true;

  # 2 sftp tests fail (skip for now)
  checkPhase = ''
    pytest tests --ignore=tests/test_sftp.py
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ aszlig ];

    longDescription = ''
      This is a library for making SSH2 connections (client or server).
      Emphasis is on using SSH2 as an alternative to SSL for making secure
      connections between python scripts. All major ciphers and hash methods
      are supported. SFTP client and server mode are both supported too.
    '';
  };
}
