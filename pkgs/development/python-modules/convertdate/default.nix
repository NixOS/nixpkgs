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
  version = "2.3.0";

  disabled = isPy27;

  # Tests are not available in the PyPI tarball so use GitHub instead.
  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "17j188zlp46zmq8qyy4z4f9v25l3zibkwzj8wp4fxqgimjnfj2nr";
  };

  propagatedBuildInputs = [
    pymeeus
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/fitnr/convertdate";
    description = "Utils for converting between date formats and calculating holidays";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
