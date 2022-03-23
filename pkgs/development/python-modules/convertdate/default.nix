{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pymeeus
, pytz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.4.0";
  disabled = isPy27;

  # Tests are not available in the PyPI tarball so use GitHub instead.
  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iOHK3UJulXJJR50nhiVgfk3bt+CAtG3BRySJ8DkBuJE=";
  };

  propagatedBuildInputs = [
    pymeeus
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "convertdate" ];

  meta = with lib; {
    homepage = "https://github.com/fitnr/convertdate";
    description = "Utils for converting between date formats and calculating holidays";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
