{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "v${version}";
    sha256 = "003radi605xjjxfa6fc9jih8j2l3yjkvanql20w9ppxs0v5vzm9w";
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
