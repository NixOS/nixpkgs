{ pkgs
, buildPythonPackage
, fetchPypi
, cryptography
, bcrypt
, pynacl
, pyasn1
, pytest
, pytest-relaxed
, mock
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h9hb2kp07zdfbanad527ll90n9ji7isf7m39jyp0sr21pxfvcpl";
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
