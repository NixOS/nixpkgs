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
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "pycron";
    rev = "refs/tags/${version}";
    hash = "sha256-t53u18lCk6tF4Hr/BrEM2gWG+QOFIEkjyEKNXIr3ibs=";
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
