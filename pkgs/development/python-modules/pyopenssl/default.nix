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


let

  # Some tests fail; we need to disable them.

  # https://github.com/pyca/pyopenssl/issues/692
  # These tests, we disable always.
  base_exclusion_list = [
    "test_set_default_verify_paths"
    "test_fallback_default_verify_paths"
  ];

  # https://github.com/pyca/pyopenssl/issues/791
  # These tests, we disable in the case that libressl is passed in as openssl.
  libressl_exclusion_list = [
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

  # Determine the final list of tests to disable.
  exclusion_list = base_exclusion_list ++ (if (stdenv.lib.hasPrefix "libressl" openssl.meta.name) then libressl_exclusion_list else []);

  # Build up the string of "not testA and not testB and not ..."
  exclusion_string = "not " + (builtins.concatStringsSep " and not " exclusion_list);

  # Compose the final string expression, including the "-k" and the single quotes.
  test_expression = if (builtins.stringLength exclusion_string == 0) then "" else ("-k '" + exclusion_string + "'");

in


buildPythonPackage rec {
  pname = "pyOpenSSL";
  version = "18.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580";
  };

  outputs = [ "out" "dev" ];

  checkPhase = ''
    runHook preCheck
    export LANG="en_US.UTF-8"
    py.test tests ${test_expression}
    runHook postCheck
  '';

  # Seems to fail unpredictably on Darwin. See http://hydra.nixos.org/build/49877419/nixlog/1
  # for one example, but I've also seen ContextTests.test_set_verify_callback_exception fail.
  doCheck = !stdenv.isDarwin;

  buildInputs = [ openssl ];
  propagatedBuildInputs = [ cryptography pyasn1 idna ];

  checkInputs = [ pytest pretend flaky glibcLocales ];
}
