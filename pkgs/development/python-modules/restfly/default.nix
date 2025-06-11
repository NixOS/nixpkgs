{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-datafiles,
  pytest-vcr,
  pytestCheckHook,
  python-box,
  pythonOlder,
  requests,
  responses,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "restfly";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stevemcgrath";
    repo = "restfly";
    tag = version;
    hash = "sha256-hHNsOFu2b4sb9zbdWVTwoU1HShLFqC+Q9/PJcEqu7Hg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    arrow
    python-box
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Test requires network access
    "test_session_ssl_error"
  ];

  pythonImportsCheck = [ "restfly" ];

  meta = with lib; {
    description = "Python RESTfly API Library Framework";
    homepage = "https://github.com/stevemcgrath/restfly";
    changelog = "https://github.com/librestfly/restfly/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
