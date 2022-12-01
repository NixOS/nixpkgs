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
    pysocks
  ];

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
    installShellCompletion --bash \
      --name http.bash extras/httpie-completion.bash
    installShellCompletion --fish \
      --name http.fish extras/httpie-completion.fish

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
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky
    "test_daemon_runner"
  ];

  meta = with lib; {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ antono relrod schneefux SuperSandro2000 ];
  };
}
