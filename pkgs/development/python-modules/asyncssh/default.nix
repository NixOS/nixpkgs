{
  lib,
  bcrypt,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  fido2,
  gssapi,
  ifaddr,
  libnacl,
  libsodium,
  nettle,
  openssh,
  openssl,
  pyopenssl,
  pytestCheckHook,
  python-pkcs11,
  setuptools,
  stdenv,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "2.24.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QGTFkOWc4ujYKi9m018xINdlgotN9ePb+we0qMJGhsk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    nettle
    typing-extensions
  ];

  buildInputs = [ libsodium ];

  optional-dependencies = {
    bcrypt = [ bcrypt ];
    fido2 = [ fido2 ];
    ifaddr = [ ifaddr ];
    gssapi = [ gssapi ];
    libnacl = [ libnacl ];
    pkcs11 = [ python-pkcs11 ];
    pyOpenSSL = [ pyopenssl ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    openssh
    openssl
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  patches = [
    # Reverts https://github.com/ronf/asyncssh/commit/4b3dec994b3aa821dba4db507030b569c3a32730
    #
    # This changed the test to avoid setting the sticky bit
    # because that's not allowed for plain files in FreeBSD.
    # However that broke the test on NixOS, failing with
    # "Operation not permitted"
    ./fix-sftp-chmod-test-nixos.patch
  ];

  disabledTestPaths = [
    # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
    "tests/sspi_stub.py"
  ];

  disabledTests = [
    # No PIN set
    "TestSKAuthCTAP2"
    # Requires network access
    "test_connect_timeout_exceeded"
    # Fails in the sandbox
    "test_forward_remote"
    # Seems weirdly filesystem specific
    "test_put_name_too_long"
    # SFTP copy ends up with an empty file on ZFS
    "test_copy_max_requests"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires network access
    "test_canonicalize_failure"
  ];

  pythonImportsCheck = [ "asyncssh" ];

  meta = {
    description = "Asynchronous SSHv2 Python client and server library";
    homepage = "https://asyncssh.readthedocs.io/";
    changelog = "https://github.com/ronf/asyncssh/blob/v${version}/docs/changes.rst";
    license = with lib.licenses; [
      epl20 # or
      gpl2Plus
    ];
    maintainers = [ ];
  };
}
