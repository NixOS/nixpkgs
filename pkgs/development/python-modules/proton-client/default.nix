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

buildPythonPackage {
  pname = "proton-client";
  version = "0.7.1-unstable-2023-04-13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-python-client";
    rev = "fb64dee036c4beb57eb92c598337ac95cd6972e6";
    hash = "sha256-nI6sw0ZM6RCP42qIzbIKJxMB5DFPwHP4hi5cvrmNDoo=";
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
    # ValueError: Invalid modulus
    "test_modulus_verification"

    # ValueError: password cannot be longer than 72 bytes
    "test_compute_v"
    "test_generate_v"
    "test_srp"
    "test_compute_v"
    "test_generate_v"
    "test_srp"
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
