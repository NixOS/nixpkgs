{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  cachecontrol,
  lxml-html-clean,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "pywebcopy";
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rajatomar788";
    repo = "pywebcopy";
    rev = "v${version}";
    hash = "sha256-XTPk3doF9dqImsLtTB03YKMWLzQrJpJtjNXe+691rZo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pywebcopy" ];

  build-system = [ setuptools ];

  dependencies = [
    cachecontrol
    lxml-html-clean
    requests
    six
  ];

  meta = {
    changelog = "https://github.com/rajatomar788/pywebcopy/blob/master/docs/changelog.md";
    description = "Python package for cloning complete webpages and websites to local storage";
    homepage = "https://github.com/rajatomar788/pywebcopy/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ d3vil0p3r ];
  };
}
