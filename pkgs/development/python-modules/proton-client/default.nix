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

  # bcrypt 5.0 raises ValueError for passwords longer than 72 bytes instead of
  # silently truncating them.  Truncate explicitly so that such passwords keep
  # producing the same hashes as with older bcrypt versions.
  postPatch = ''
    substituteInPlace proton/srp/util.py \
      --replace-fail 'bcrypt.hashpw(password,' 'bcrypt.hashpw(password[:72],'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # GnuPG needs a writable home directory to import the SRP modulus key
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "proton" ];

  meta = {
    description = "Python Proton client module";
    homepage = "https://github.com/ProtonMail/proton-python-client";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
