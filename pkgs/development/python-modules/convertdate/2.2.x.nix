{ lib
, buildPythonPackage
, fetchFromGitHub
, pymeeus
, pytz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.2.2";

  # Tests are not available in the PyPI tarball so use GitHub instead.
  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "07x1j6jgkmrzdpv2lhpp4n16621mpmlylvwdwsggdjivhzvc3x9q";
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
