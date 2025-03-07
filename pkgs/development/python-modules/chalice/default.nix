{
  lib,
  attrs,
  botocore,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hypothesis,
  inquirer,
  jmespath,
  mock,
  mypy-extensions,
  pip,
  pytest7CheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  six,
  typing-extensions,
  watchdog,
  websocket-client,
  wheel,
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-m3pSD4fahBW6Yt/w07Co4fTZD7k6as5cPwoK5QSry6M=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "inquirer>=2.7.0,<3.0.0" "inquirer" \
      --replace "pip>=9,<23.1" "pip" \
  '';

  propagatedBuildInputs = [
    attrs
    botocore
    click
    inquirer
    jmespath
    mypy-extensions
    pip
    pyyaml
    setuptools
    six
    typing-extensions
    wheel
    watchdog
  ];

  nativeCheckInputs = [
    hypothesis
    mock
    pytest7CheckHook
    requests
    websocket-client
  ];

  disabledTestPaths = [
    # Don't check the templates and the sample app
    "chalice/templates"
    "docs/source/samples/todo-app/code/tests/test_db.py"
    # Requires credentials
    "tests/aws/test_features.py"
    # Requires network access
    "tests/aws/test_websockets.py"
    "tests/integration/test_package.py"
  ];

  disabledTests = [
    # Requires network access
    "test_update_domain_name_failed"
    "test_can_reload_server"
    # Content for the tests is missing
    "test_can_import_env_vars"
    "test_stack_trace_printed_on_error"
    # Don't build
    "test_can_generate_pipeline_for_all"
    "test_build_wheel"
    # https://github.com/aws/chalice/issues/1850
    "test_resolve_endpoint"
    "test_endpoint_from_arn"
    # Tests require dist
    "test_setup_tar_gz_hyphens_in_name"
    "test_both_tar_gz"
    "test_both_tar_bz2"
  ];

  pythonImportsCheck = [ "chalice" ];

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    mainProgram = "chalice";
    homepage = "https://github.com/aws/chalice";
    changelog = "https://github.com/aws/chalice/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
