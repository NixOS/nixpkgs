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
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85b1245054e5d7592b9088cc6d08da22445417912d3a3e48138675c7a8616438";
  };

  propagatedBuildInputs = [ bcrypt cryptography pynacl pyasn1 ];

  # with python 3.9.6+, the deprecation warnings will fail the test suite
  # see: https://github.com/pyinvoke/invoke/issues/829
  doCheck = false;
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
