{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "durationpy";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "icholy";
    repo = "durationpy";
    tag = version;
    hash = "sha256-tJ3zOCROkwFWzTgIKx+0H7J1rNkwy5XJPh8Zec7jJ5g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "durationpy" ];

  meta = {
    description = "Module for converting between datetime.timedelta and Go's time.Duration strings";
    homepage = "https://github.com/icholy/durationpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
