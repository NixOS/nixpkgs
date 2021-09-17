{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gd2jana5w6bn7z58di4a8dwcxvc8rx282jawbw7ws7qm2a5klz3";
  };

  # disable coverage and linting
  postPatch = ''
    sed -i '/--cov/d' pytest.ini
    sed -i '/--flake8/d' pytest.ini
  '';

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
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
