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
, pytest-relaxed
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "3.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ajd3qWGshtvvN1xfW41QAUoaltD9fwVKQ7yIATSw/3c=";
  };

  patches = [
    # Fix usage of dsa keys, https://github.com/paramiko/paramiko/pull/1606/
    (fetchpatch {
      url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
      hash = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
    })
  ];

  propagatedBuildInputs = [
    bcrypt
    cryptography
    pynacl
  ];

  passthru.optional-dependencies = {
    gssapi = [
      gssapi
      pyasn1
    ];
    ed25519 = [ ];
    invoke = [
      invoke
    ];
  };

  nativeCheckInputs = [
    mock
    icecream
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
    changelog = "https://github.com/paramiko/paramiko/blob/${version}/sites/www/changelog.rst";
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
