{ lib
, bcrypt
, buildPythonPackage
, cryptography
, fetchpatch
, fetchPypi
, gssapi
, invoke
, mock
, pyasn1
, pynacl
, pytest-relaxed
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AD5r7nwDTCH7sFG/g9wKnuQQYgTdPFMFTHFFLMTsOTg=";
  };

  patches = [
    # Fix usage of dsa keys
    # https://github.com/paramiko/paramiko/pull/1606/
    (fetchpatch {
      url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
      sha256 = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
    })
  ];

  propagatedBuildInputs = [
    cryptography
    pyasn1
    six
  ] ++ passthru.optional-dependencies.ed25519; # remove on 3.0 update

  checkInputs = [
    invoke
    mock
    pytest-relaxed
    pytestCheckHook
  ];

  # with python 3.9.6+, the deprecation warnings will fail the test suite
  # see: https://github.com/pyinvoke/invoke/issues/829
  # pytest-relaxed does not work with pytest 6
  # see: https://github.com/bitprophet/pytest-relaxed/issues/12
  doCheck = false;

  disabledTestPaths = [
    "tests/test_sftp.py"
    "tests/test_config.py"
  ];

  pythonImportsCheck = [
    "paramiko"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.optional-dependencies = {
    gssapi = [ pyasn1 gssapi ];
    ed25519 = [ pynacl bcrypt ];
    invoke = [ invoke ];
  };

  meta = with lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    license = licenses.lgpl21Plus;
    longDescription = ''
      Library for making SSH2 connections (client or server). Emphasis is
      on using SSH2 as an alternative to SSL for making secure connections
      between python scripts. All major ciphers and hash methods are
      supported. SFTP client and server mode are both supported too.
    '';
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
