{ lib
, buildPythonPackage
, fetchFromGitHub
, loguru
, pytestCheckHook
, six
, pytest-mypy
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U6yamXbG8CUrNnFmGTBpHUelZSgoaNyB2CdUSH9WdMA=";
  };

  # disable coverage and linting
  postPatch = ''
    sed -i '/--cov/d' pytest.ini
    sed -i '/--flake8/d' pytest.ini
  '';

  propagatedBuildInputs = [
    loguru
    six
  ];

  checkInputs = [
    pytest-mypy
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "_python_utils_tests"
  ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    license = licenses.bsd3;
  };
}
