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
  version = "4.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = "v${version}";
    hash = "sha256-qUNMjnIhQpUSQY0kN9bA4IxQx8fiFIA6p8rPqNqdjNo=";
  };

  postPatch = ''
    # https://github.com/libkeepass/pykeepass/pull/378
    substituteInPlace pyproject.toml \
      --replace-fail 'packages = ["pykeepass"]' 'packages = ["pykeepass", "pykeepass.kdbx_parsing"]'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    argon2-cffi
    construct
    lxml
    pycryptodomex
    setuptools
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
