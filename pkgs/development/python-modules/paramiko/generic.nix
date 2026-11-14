{
  lib,
  bcrypt,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  icecream,
  invoke,
  pynacl,
  pytest-relaxed,
  pytestCheckHook,
  setuptools,

  version,
  hash ? "",
  source ? fetchFromGitHub {
    owner = "paramiko";
    repo = "paramiko";
    tag = version;
    inherit hash;
  },
  patches ? [ ],
  extraNativeCheckInputs ? [ ], # allow defining additional nativeCheckInputs, primarily used for paramiko_3
}:

buildPythonPackage (finalAttrs: {
  pname = "paramiko";

  inherit version;
  inherit patches;

  src = source;

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    cryptography
    invoke
    pynacl
  ];

  nativeCheckInputs = [
    icecream
    pytestCheckHook
    pytest-relaxed
  ]
  ++ extraNativeCheckInputs;

  pythonImportsCheck = [ "paramiko" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/paramiko/paramiko/";
    changelog = "https://github.com/paramiko/paramiko/blob/${finalAttrs.src.tag}/sites/www/changelog.rst";
    description = "Native Python SSHv2 protocol library";
    license = lib.licenses.lgpl21Plus;
    longDescription = ''
      Library for making SSH2 connections (client or server). Emphasis is
      on using SSH2 as an alternative to SSL for making secure connections
      between python scripts. All major ciphers and hash methods are
      supported. SFTP client and server mode are both supported too.
    '';
  };
})
