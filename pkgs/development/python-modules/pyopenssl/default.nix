{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  setuptools,
  cryptography,
  pytestCheckHook,
  pretend,
  sphinxHook,
  sphinx-rtd-theme,
  pytest-rerunfailures,
}:

buildPythonPackage rec {
  pname = "pyopenssl";
  version = "24.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "pyopenssl";
    rev = "refs/tags/${version}";
    hash = "sha256-/TQnDWdycN4hQ7ZGvBhMJEZVafmL+0wy9eJ8hC6rfio=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    openssl
    sphinxHook
    sphinx-rtd-theme
  ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    pretend
    pytest-rerunfailures
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  disabledTests =
    [
      # https://github.com/pyca/pyopenssl/issues/692
      # These tests, we disable always.
      "test_set_default_verify_paths"
      "test_fallback_default_verify_paths"
      # https://github.com/pyca/pyopenssl/issues/768
      "test_wantWriteError"
      # https://github.com/pyca/pyopenssl/issues/1043
      "test_alpn_call_failure"
    ]
    ++ lib.optionals (lib.hasPrefix "libressl" openssl.meta.name) [
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
    ]
    ++ lib.optionals (lib.versionAtLeast (lib.getVersion openssl.name) "1.1") [
      # these tests are extremely tightly wed to the exact output of the openssl cli tool, including exact punctuation.
      "test_dump_certificate"
      "test_dump_privatekey_text"
      "test_dump_certificate_request"
      "test_export_text"
    ]
    ++ lib.optionals stdenv.hostPlatform.is32bit [
      # https://github.com/pyca/pyopenssl/issues/974
      "test_verify_with_time"
    ];

  meta = with lib; {
    description = "Python wrapper around the OpenSSL library";
    homepage = "https://github.com/pyca/pyopenssl";
    changelog = "https://github.com/pyca/pyopenssl/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
