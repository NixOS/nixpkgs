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
}:

buildPythonPackage (finalAttrs: {
  pname = "paramiko";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paramiko";
    repo = "paramiko";
    tag = finalAttrs.version;
    hash = "sha256-zzbM2oGaZ5jkIN7LyDGuMAKSpSmUwpBbup6MBVdTaXA=";
  };

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
