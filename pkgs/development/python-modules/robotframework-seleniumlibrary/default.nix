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
  version = "6.7.1";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    tag = "v${version}";
    hash = "sha256-pKAOVycckUCe93wMk9kql1lY6WeUTiS4lk/skDAfKCY=";
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
    changelog = "https://github.com/robotframework/SeleniumLibrary/blob/${src.tag}/docs/SeleniumLibrary-${version}.rst";
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
