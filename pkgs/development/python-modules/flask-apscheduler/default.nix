{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  flask,
  apscheduler,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "flask-apscheduler";
  version = "1.13.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "viniciuschiele";
    repo = "flask-apscheduler";
    tag = version;
    hash = "sha256-0gZueUuBBpKGWE6OCJiJL/EEIMqCVc3hgLKwIWFuSZI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    apscheduler
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "flask_apscheduler" ];

  meta = {
    description = "APScheduler support for Flask";
    homepage = "https://github.com/viniciuschiele/flask-apscheduler";
    changelog = "https://github.com/viniciuschiele/flask-apscheduler/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
