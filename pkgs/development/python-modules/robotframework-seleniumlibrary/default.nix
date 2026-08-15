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

buildPythonPackage (finalAttrs: {
  pname = "robotframework-seleniumlibrary";
  version = "6.9.0";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NiB1dJWivyDc1ucldQ2cs3jTWt3hHY6AGsboKPmY+mo=";
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
    changelog = "https://github.com/robotframework/SeleniumLibrary/blob/${finalAttrs.src.tag}/docs/SeleniumLibrary-${finalAttrs.version}.rst";
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
