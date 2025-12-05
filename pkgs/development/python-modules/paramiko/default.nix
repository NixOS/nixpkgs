{
  lib,
  bcrypt,
  buildPythonPackage,
  cryptography,
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
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aiXwezgMycmojSuSCtNxZ6xGZ/jZiGzOvY+Q9lS11p8=";
  };

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
  ++ lib.concatAttrValues optional-dependencies;

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
