{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  argon2-cffi,
  construct,
  lxml,
  pycryptodomex,
  pyotp,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pykeepass";
  version = "4.1.0.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = "refs/tags/v${version}";
    hash = "sha256-64is/XoRF/kojqd4jQIAQi1od8TRhiv9uR+WNIGvP2A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argon2-cffi
    construct
    lxml
    pycryptodomex
  ];

  propagatedNativeBuildInputs = [ argon2-cffi ];

  nativeCheckInputs = [
    pyotp
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pykeepass" ];

  meta = with lib; {
    homepage = "https://github.com/libkeepass/pykeepass";
    changelog = "https://github.com/libkeepass/pykeepass/blob/${src.rev}/CHANGELOG.rst";
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
