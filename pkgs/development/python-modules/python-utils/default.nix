{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
, pytest-mypy
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+NgcVIDM9f2OKBpJNWlSyFxEONltPWJSWIu400/5RkQ=
";
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
