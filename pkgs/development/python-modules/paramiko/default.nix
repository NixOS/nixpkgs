{ pkgs
, buildPythonPackage
, fetchPypi
, cryptography
, bcrypt
, invoke
, pynacl
, pyasn1
, pytestCheckHook
, pytest-relaxed
, mock
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035";
  };

  propagatedBuildInputs = [ bcrypt cryptography pynacl pyasn1 ];

  checkInputs = [ invoke pytestCheckHook pytest-relaxed mock ];

  disabledTestPaths = [
    "tests/test_sftp.py"
    "tests/test_config.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with pkgs.lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    license = licenses.lgpl21Plus;
    longDescription = ''
      This is a library for making SSH2 connections (client or server).
      Emphasis is on using SSH2 as an alternative to SSL for making secure
      connections between python scripts. All major ciphers and hash methods
      are supported. SFTP client and server mode are both supported too.
    '';
  };
}
