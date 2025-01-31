{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  robotframework,
  robotframework-pythonlibcore,
  selenium,
  approvaltests,
  pytest-mockito,
  pytestCheckHook,
  robotstatuschecker,
}:

buildPythonPackage rec {
  pname = "robotframework-seleniumlibrary";
  version = "6.6.1";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ULY0FH1RFQIlhS45LU3vUKi6urZJHiDgi6NdqU5tV2g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    robotframework
    robotframework-pythonlibcore
    selenium
  ];

  nativeCheckInputs = [
    approvaltests
    pytest-mockito
    pytestCheckHook
    robotstatuschecker
  ];

  preCheck = ''
    mkdir utest/output_dir
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/robotframework/SeleniumLibrary/blob/${src.rev}/docs/SeleniumLibrary-${version}.rst";
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
