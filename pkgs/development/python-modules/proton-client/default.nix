{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  substituteAll,
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
  disabled = pythonOlder "3.7";

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
    (substituteAll {
      src = ./0001-OpenSSL-path-fix.patch;
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

  meta = with lib; {
    description = "Python Proton client module";
    homepage = "https://github.com/ProtonMail/proton-python-client";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
