{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gns9v5144cj03p7qbb3822scb6pwrlgr6niixpkynwqkcwjfg4c";
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
