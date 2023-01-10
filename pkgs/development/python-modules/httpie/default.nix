{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, installShellFiles
, pandoc
, pythonOlder
# BuildInputs
, charset-normalizer
, defusedxml
, multidict
, pygments
, requests
, requests-toolbelt
, setuptools
, rich
, pysocks
# CheckInputs
, pytest-httpbin
, pytest-lazy-fixture
, pytest-mock
, pytestCheckHook
, responses
, werkzeug
}:

buildPythonPackage rec {
  pname = "httpie";
  version = "3.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "httpie";
    rev = version;
    hash = "sha256-WEe8zSlNckl7bPBi6u8mHQ1/xPw3kE81F8Xr15TchgM=";
  };

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  propagatedBuildInputs = [
    charset-normalizer
    defusedxml
    multidict
    pygments
    requests
    requests-toolbelt
    setuptools
    rich
  ] ++ requests.optional-dependencies.socks;


  checkInputs = [
    pytest-httpbin
    pytest-lazy-fixture
    pytest-mock
    pytestCheckHook
    responses
    werkzeug
  ];

  postInstall = ''
    # install completions
    installShellCompletion --cmd http \
      --bash extras/httpie-completion.bash \
      --fish extras/httpie-completion.fish

    # convert the docs/README.md file
    pandoc --standalone -f markdown -t man docs/README.md -o docs/http.1
    installManPage docs/http.1
  '';

  pytestFlagsArray = [
    "httpie"
    "tests"
  ];

  pythonImportsCheck = [
    "httpie"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # flaky
    "tests/test_plugins_cli.py"
  ];

  disabledTests = [
    # flaky
    "test_stdin_read_warning"
    # Re-evaluate those tests with the next release
    "test_duplicate_keys_support_from_response"
    "test_invalid_xml"
    "test_json_formatter_with_body_preceded_by_non_json_data"
    "test_pretty_options_with_and_without_stream_with_converter"
    "test_response_mime_overwrite"
    "test_terminal_output_response_charset_detection"
    "test_terminal_output_response_charset_override"
    "test_terminal_output_response_content_type_charset_with_stream"
    "test_terminal_output_response_content_type_charset"
    "test_valid_xml"
    "test_xml_format_options"
    "test_xml_xhtm"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky
    "test_daemon_runner"
  ];

  meta = with lib; {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    changelog = "https://github.com/httpie/httpie/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ antono relrod schneefux ];
  };
}
