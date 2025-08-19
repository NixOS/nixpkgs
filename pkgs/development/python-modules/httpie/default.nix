{
  lib,
  stdenv,
  buildPythonPackage,
  charset-normalizer,
  defusedxml,
  fetchFromGitHub,
  installShellFiles,
  multidict,
  pandoc,
  pip,
  pygments,
  pytest-httpbin,
  pytest-lazy-fixture,
  pytest-mock,
  pytestCheckHook,
  requests-toolbelt,
  requests,
  responses,
  rich,
  setuptools,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "httpie";
  version = "3.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "httpie";
    tag = version;
    hash = "sha256-uZKkUUrPPnLHPHL8YrZgfsyCsSOR0oZ2eFytiV0PIUY=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "requests"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  dependencies = [
    charset-normalizer
    defusedxml
    multidict
    pygments
    requests
    requests-toolbelt
    setuptools
    rich
  ]
  ++ requests.optional-dependencies.socks;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pip
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

  enabledTestPaths = [
    "httpie"
    "tests"
  ];

  pythonImportsCheck = [ "httpie" ];

  disabledTestPaths = [
    # Tests are flaky
    "tests/test_plugins_cli.py"
  ];

  disabledTests = [
    # argparse output changed
    "test_naked_invocation"
    # Test is flaky
    "test_stdin_read_warning"
    # httpbin compatibility issues
    "test_binary_suppresses_when_terminal"
    "test_binary_suppresses_when_not_terminal_but_pretty"
    "test_binary_included_and_correct_when_suitable"
    # charset-normalizer compat issue
    # https://github.com/httpie/cli/issues/1628
    "test_terminal_output_response_charset_detection"
    "test_terminal_output_request_charset_detection"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test is flaky
    "test_daemon_runner"
  ];

  meta = with lib; {
    description = "Command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    changelog = "https://github.com/httpie/httpie/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      antono
      relrod
      schneefux
    ];
  };
}
