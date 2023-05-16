{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, openssl
, cryptography
, pytestCheckHook
, pretend
, sphinxHook
, sphinx-rtd-theme
, flaky
}:

buildPythonPackage rec {
  pname = "pyopenssl";
<<<<<<< HEAD
  version = "23.2.0";
=======
  version = "23.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    pname = "pyOpenSSL";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-J2+TH1WkUufeppxxc+mE6ypEB85BPJGKo0tV+C+bi6w=";
=======
    hash = "sha256-hBSYub7GFiOxtsR+u8AjZ8B9YODhlfGXkIF/EMyNsLc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    openssl
    sphinxHook
    sphinx-rtd-theme
  ];

  postPatch = ''
    # remove cryptography pin
    sed "/cryptography/ s/,<[0-9]*//g" setup.py
  '';

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    flaky
    pretend
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  disabledTests = [
    # https://github.com/pyca/pyopenssl/issues/692
    # These tests, we disable always.
    "test_set_default_verify_paths"
    "test_fallback_default_verify_paths"
    # https://github.com/pyca/pyopenssl/issues/768
    "test_wantWriteError"
    # https://github.com/pyca/pyopenssl/issues/1043
    "test_alpn_call_failure"
  ] ++ lib.optionals (lib.hasPrefix "libressl" openssl.meta.name) [
    # https://github.com/pyca/pyopenssl/issues/791
    # These tests, we disable in the case that libressl is passed in as openssl.
    "test_op_no_compression"
    "test_npn_advertise_error"
    "test_npn_select_error"
    "test_npn_client_fail"
    "test_npn_success"
    "test_use_certificate_chain_file_unicode"
    "test_use_certificate_chain_file_bytes"
    "test_add_extra_chain_cert"
    "test_set_session_id_fail"
    "test_verify_with_revoked"
    "test_set_notAfter"
    "test_set_notBefore"
  ] ++ lib.optionals (lib.versionAtLeast (lib.getVersion openssl.name) "1.1") [
    # these tests are extremely tightly wed to the exact output of the openssl cli tool, including exact punctuation.
    "test_dump_certificate"
    "test_dump_privatekey_text"
    "test_dump_certificate_request"
    "test_export_text"
  ] ++ lib.optionals stdenv.is32bit [
    # https://github.com/pyca/pyopenssl/issues/974
    "test_verify_with_time"
  ];

  meta = with lib; {
    description = "Python wrapper around the OpenSSL library";
    homepage = "https://github.com/pyca/pyopenssl";
    changelog = "https://github.com/pyca/pyopenssl/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
