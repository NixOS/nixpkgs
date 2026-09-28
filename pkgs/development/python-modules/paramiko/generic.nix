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

  version, # paramiko upstream version
  hash ? "", # hash of the upstream source for the given version
  source ? fetchFromGitHub {
    owner = "paramiko";
    repo = "paramiko";
    tag = version;
    inherit hash;
  },
}:

buildPythonPackage (finalAttrs: {
  pname = "paramiko";
  inherit version;
  pyproject = true;

  src = source;
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
  ];

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
