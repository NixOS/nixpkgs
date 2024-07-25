{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "2.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8fjKCvZCEvvpmxvuEl7lobU6nBtDOWjYvKiBe3nSN/M=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tzlocal
  ];

  pythonImportsCheck = [ "croniter" ];

  meta = with lib; {
    description = "Library to iterate over datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    changelog = "https://github.com/kiorky/croniter/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
