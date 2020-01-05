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
, fetchpatch
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
    # https://github.com/pyca/pyopenssl/issues/768
    "test_wantWriteError"
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

  patches = [
    # 4 patches for 2020 bug
    # https://github.com/pyca/pyopenssl/pull/828
    (fetchpatch {
      url = https://github.com/pyca/pyopenssl/commit/0d2fd1a24b30077ead6960bd63b4a9893a57c101.patch;
      sha256 = "1c27g53qrwxddyx04sxf8yvj7xgbaabla7mc1cgbfd426rncbqf3";
    })
    (fetchpatch {
      url = https://github.com/pyca/pyopenssl/commit/d08a742573c3205348a4eec9a65abaf6c16110c4.patch;
      sha256 = "18xn8s1wpycz575ivrbsbs0qd2q48z8pdzsjzh8i60xba3f8yj2f";
    })
    (fetchpatch {
      url = https://github.com/pyca/pyopenssl/commit/60b9e10e6da7ccafaf722def630285f54510ed12.patch;
      sha256 = "0aw8qvy8m0bhgp39lmbcrpprpg4bhpssm327hyrk476wwgajk01j";
    })
    (fetchpatch {
      url = https://github.com/pyca/pyopenssl/commit/7a37cc23fcbe43abe785cd4badd14bdc7acfb175.patch;
      sha256 = "1c7zb568rs71rsl16p6dq7aixwlkgzfnba4vzmfvbmy3zsnaslq2";
    })
  ];

  # Seems to fail unpredictably on Darwin. See http://hydra.nixos.org/build/49877419/nixlog/1
  # for one example, but I've also seen ContextTests.test_set_verify_callback_exception fail.
  doCheck = !stdenv.isDarwin;

  nativeBuildInputs = [ openssl ];
  propagatedBuildInputs = [ cryptography pyasn1 idna ];

  checkInputs = [ pytest pretend flaky glibcLocales ];
}
