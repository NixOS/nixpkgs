{ lib
, bcrypt
, buildPythonPackage
, cryptography
, fetchpatch
, fetchPypi
, gssapi
, icecream
, invoke
, mock
, pyasn1
, pynacl
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "3.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ajd3qWGshtvvN1xfW41QAUoaltD9fwVKQ7yIATSw/3c=";
  };

  patches = [
    # Fix usage of dsa keys
    # https://github.com/paramiko/paramiko/pull/1606/
    (fetchpatch {
      url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
      hash = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
    })
  ];

  propagatedBuildInputs = [
    bcrypt
    cryptography
    pyasn1
    six
  ] ++ passthru.optional-dependencies.ed25519; # remove on 3.0 update

  passthru.optional-dependencies = {
    gssapi = [ pyasn1 gssapi ];
    ed25519 = [ pynacl bcrypt ];
    invoke = [ invoke ];
  };

  nativeCheckInputs = [
    icecream
    mock
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # disable tests that require pytest-relaxed, which is broken
    "tests/test_client.py"
    "tests/test_ssh_gss.py"
  ];

  pythonImportsCheck = [
    "paramiko"
  ];

  __darwinAllowLocalNetworking = true;

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
    maintainers = with maintainers; [ ];
  };
}
