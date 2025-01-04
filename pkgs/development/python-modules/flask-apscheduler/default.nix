{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,

  flask,
  apscheduler,
  python-dateutil,

  pytestCheckHook,
}:
let
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "viniciuschiele";
    repo = "flask-apscheduler";
    rev = "refs/tags/${version}";
    hash = "sha256-0gZueUuBBpKGWE6OCJiJL/EEIMqCVc3hgLKwIWFuSZI=";
  };
in
buildPythonPackage {
  pname = "flask-apscheduler";
  inherit version src;
  pyproject = true;

  disabled = pythonOlder "3.8";

  build-system = [
    setuptools
  ];

  dependencies = [
    flask
    apscheduler
    python-dateutil
  ];

  pythonImportsCheck = [ "flask_apscheduler" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Adds APScheduler support to Flask";
    homepage = "https://github.com/viniciuschiele/flask-apscheduler";
    changelog = "https://github.com/viniciuschiele/flask-apscheduler/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
