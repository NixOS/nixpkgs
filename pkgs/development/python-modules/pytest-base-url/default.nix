{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  pytest,
  pytest-localserver,
  pytest-metadata,
  requests,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-base-url";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-base-url";
    tag = version;
    hash = "sha256-3P3Uk3QoznAtNODLjXFbeNn3AOfp9owWU2jqkxTEAa4=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ requests ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-localserver
    pytest-metadata
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # should be xfail? or mocking doesn't work
    "test_url_fails"
  ];

  pythonImportsCheck = [ "pytest_base_url" ];

  meta = with lib; {
    description = "Pytest plugin for URL based tests";
    homepage = "https://github.com/pytest-dev/pytest-base-url";
    changelog = "https://github.com/pytest-dev/pytest-base-url/blob/${src.rev}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sephi ];
  };
}
