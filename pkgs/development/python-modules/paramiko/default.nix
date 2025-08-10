{
  lib,
  bcrypt,
  buildPythonPackage,
  cryptography,
  fetchpatch,
  fetchPypi,
  gssapi,
  icecream,
  invoke,
  mock,
  pyasn1,
  pynacl,
  pytest-relaxed,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "3.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ssZlvEWyshW9fX8DmQGxSwZ9oA86EeZkCZX9WPJmSCI=";
  };

  patches = [
    # Fix usage of dsa keys
    # https://github.com/paramiko/paramiko/pull/1606/
    (fetchpatch {
      url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
      hash = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    cryptography
    pynacl
  ];

  optional-dependencies = {
    gssapi = [
      pyasn1
      gssapi
    ];
    ed25519 = [ ];
    invoke = [ invoke ];
  };

  nativeCheckInputs = [
    icecream
    mock
    pytestCheckHook
    pytest-relaxed
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "paramiko" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/paramiko/paramiko/";
    changelog = "https://github.com/paramiko/paramiko/blob/${version}/sites/www/changelog.rst";
    description = "Native Python SSHv2 protocol library";
    license = lib.licenses.lgpl21Plus;
    longDescription = ''
      Library for making SSH2 connections (client or server). Emphasis is
      on using SSH2 as an alternative to SSL for making secure connections
      between python scripts. All major ciphers and hash methods are
      supported. SFTP client and server mode are both supported too.
    '';
    teams = [ lib.teams.helsinki-systems ];
  };
}
