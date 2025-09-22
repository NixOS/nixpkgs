{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  arrow,
  delorean,
  pendulum,
  pytestCheckHook,
  pytz,
  udatetime,
}:

buildPythonPackage rec {
  pname = "pycron";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "pycron";
    tag = version;
    hash = "sha256-AuDqElqu/cbTASHQfWM85JHu8DvkwArZ2leMZSB+XVM=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    arrow
    delorean
    pendulum
    pytestCheckHook
    pytz
    udatetime
  ];

  disabledTestPaths = [
    # depens on nose
    "tests/test_has_been.py"
  ];

  pythonImportsCheck = [ "pycron" ];

  meta = with lib; {
    description = "Simple cron-like parser for Python, which determines if current datetime matches conditions";
    license = licenses.mit;
    homepage = "https://github.com/kipe/pycron";
    maintainers = with maintainers; [ globin ];
  };
}
