{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  bcrypt,
  pyopenssl,
  python-gnupg,
  pytestCheckHook,
  requests,
  openssl,
}:

buildPythonPackage rec {
  pname = "proton-client";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-python-client";
    rev = version;
    hash = "sha256-mhPq9O/LCu3+E1jKlaJmrI8dxbA9BIwlc34qGwoxi5g=";
  };

  propagatedBuildInputs = [
    bcrypt
    pyopenssl
    python-gnupg
    requests
  ];

  buildInputs = [ openssl ];

  patches = [
    # Patches library by fixing the openssl path
    (replaceVars ./0001-OpenSSL-path-fix.patch {
      openssl = openssl.out;
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    #ValueError: Invalid modulus
    "test_modulus_verification"
  ];

  pythonImportsCheck = [ "proton" ];

  meta = {
    description = "Python Proton client module";
    homepage = "https://github.com/ProtonMail/proton-python-client";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
