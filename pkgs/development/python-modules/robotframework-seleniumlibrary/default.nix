{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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
  version = "6.4.0";
  pyproject = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Rjbdn1WXdXLn//HLtHwVrlLD+3vw9mgre/0wvMb+xbc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    changelog = "https://github.com/robotframework/SeleniumLibrary/blob/${src.rev}/docs/SeleniumLibrary-${version}.rst";
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
