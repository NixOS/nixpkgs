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
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O/+jvdzzxUFaQdAfUM9p40fPPDNN+stTauCD993HH6Y=";
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
