{
  lib,
  blinker,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  pythonOlder,
  setuptools,
  webob,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bugsnag";
    repo = "bugsnag-python";
    tag = "v${version}";
    hash = "sha256-aN7/MpTdsRsAINPXOmSau4pG1+F8gmvjlx5czKpx7H8=";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace-fail \
      "--cov=bugsnag --cov-report html --cov-append --cov-report term" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ webob ];

  optional-dependencies = {
    flask = [
      blinker
      flask
    ];
  };

  pythonImportsCheck = [ "bugsnag" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Extra dependencies
    "tests/integrations"
    # Flaky due to timeout
    "tests/test_client.py::ClientTest::test_flush_waits_for_outstanding_events_before_returning"
    # Flaky due to timeout
    "tests/test_client.py::ClientTest::test_flush_waits_for_outstanding_sessions_before_returning"
    # Flaky failure due to AssertionError: assert 0 == 3
    "tests/test_client.py::ClientTest::test_aws_lambda_handler_decorator_warns_of_potential_timeout"
    # Flaky failure due to AssertionError: assert 0 == 1
    "tests/test_client.py::ClientTest::test_exception_hook_does_not_leave_a_breadcrumb_if_errors_are_disabled"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Automatic error monitoring for Python applications";
    homepage = "https://github.com/bugsnag/bugsnag-python";
    changelog = "https://github.com/bugsnag/bugsnag-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
