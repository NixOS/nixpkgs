{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  argon2-cffi,
  construct,
  importlib-metadata,
  lxml,
  pycryptodomex,
  pyotp,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pykeepass";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MGlkpnWTBO7m3u1v8yZiKMtXnEv+rsy6+J1mJILdx0I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argon2-cffi
    construct
    importlib-metadata
    lxml
    pycryptodomex
    pyotp
  ];

  propagatedNativeBuildInputs = [ argon2-cffi ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pykeepass" ];

  meta = {
    homepage = "https://github.com/libkeepass/pykeepass";
    changelog = "https://github.com/libkeepass/pykeepass/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
