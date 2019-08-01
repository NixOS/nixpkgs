{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
, cryptography
, pyasn1
, idna
, pytest
, pretend
, flaky
, glibcLocales
}:

with stdenv.lib;


let
  # https://github.com/pyca/pyopenssl/issues/791
  # These tests, we disable in the case that libressl is passed in as openssl.
  failingLibresslTests = [
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
  ];

  # these tests are extremely tightly wed to the exact output of the openssl cli tool,
  # including exact punctuation.
  failingOpenSSL_1_1Tests = [
    "test_dump_certificate"
    "test_dump_privatekey_text"
    "test_dump_certificate_request"
    "test_export_text"
  ];

  disabledTests = [
    # https://github.com/pyca/pyopenssl/issues/692
    # These tests, we disable always.
    "test_set_default_verify_paths"
    "test_fallback_default_verify_paths"
  ] ++ (
    optionals (hasPrefix "libressl" openssl.meta.name) failingLibresslTests
  ) ++ (
    optionals (versionAtLeast (getVersion openssl.name) "1.1") failingOpenSSL_1_1Tests
  );

  # Compose the final string expression, including the "-k" and the single quotes.
  testExpression = optionalString (disabledTests != [])
    "-k 'not ${concatStringsSep " and not " disabledTests}'";

in


buildPythonPackage rec {
  pname = "pyOpenSSL";
  version = "19.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200";
  };

  outputs = [ "out" "dev" ];

  checkPhase = ''
    runHook preCheck
    export LANG="en_US.UTF-8"
    py.test tests ${testExpression}
    runHook postCheck
  '';

  # Seems to fail unpredictably on Darwin. See http://hydra.nixos.org/build/49877419/nixlog/1
  # for one example, but I've also seen ContextTests.test_set_verify_callback_exception fail.
  doCheck = !stdenv.isDarwin;

  nativeBuildInputs = [ openssl ];
  propagatedBuildInputs = [ cryptography pyasn1 idna ];

  checkInputs = [ pytest pretend flaky glibcLocales ];
}
