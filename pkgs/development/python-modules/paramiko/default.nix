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

  checkInputs = [ invoke pytestCheckHook mock pytest-relaxed ];

  __darwinAllowLocalNetworking = true;

  # 2 sftp tests fail (skip for now)
  # test_config relies on artifacts to be to downloaded
  # RSA tests don't have valid keys
  disabledTestPaths = [
    "tests/test_sftp.py"
    "tests/test_config.py"
  ];

  meta = with pkgs.lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    longDescription = ''
      This is a library for making SSH2 connections (client or server).
      Emphasis is on using SSH2 as an alternative to SSL for making secure
      connections between python scripts. All major ciphers and hash methods
      are supported. SFTP client and server mode are both supported too.
    '';
    license = licenses.lgpl21Plus;
    maintainers = [];
  };
}
