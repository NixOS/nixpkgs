{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  arrow,
  delorean,
  pendulum,
  pytestCheckHook,
  pytz,
  udatetime,
}:

buildPythonPackage rec {
  pname = "pycron";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "pycron";
    rev = version;
    hash = "sha256-+67yU2o31SdgnV3CtiEkLHDltQYgosnqxEuO51rGE4o=";
  };

  build-system = [ setuptools ];

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
