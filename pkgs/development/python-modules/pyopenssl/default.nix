{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, openssl
, cryptography
, pytestCheckHook
, pretend
, flaky
}:

buildPythonPackage rec {
  pname = "pyopenssl";
  version = "22.1.0";

  outputs = [ "out" "dev" ];

  src = fetchPypi {
    pname = "pyOpenSSL";
    inherit version;
    sha256 = "sha256-eoO3snLdWVIi1nL1zimqAw8fuDdjDvIp9i5y45XOiWg=";
  };

  patches = [
    (fetchpatch {
      name = "fix-flaky-darwin-handshake-tests.patch";
      url = "https://github.com/pyca/pyopenssl/commit/8a75898356806784caf742e8277ef03de830ce11.patch";
      hash = "sha256-UVsZ8Nq1jUTZhOUAilRgdtqMYp4AN7qvWHqc6RleqRI=";
    })
  ];

  postPatch = ''
    # remove cryptography pin
    sed "/cryptography/ s/,<[0-9]*//g" setup.py
  '';

  nativeBuildInputs = [ openssl ];
  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ pytestCheckHook pretend flaky ];

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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
