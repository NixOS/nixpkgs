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
  version = "2.3.1";

  disabled = isPy27;

  # Tests are not available in the PyPI tarball so use GitHub instead.
  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = version;
    sha256 = "1g8sgd3xc9viy0kb1i4xp6bdn1hzwhrnk8kmismla88scivrhq32";
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
