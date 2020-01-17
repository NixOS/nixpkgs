{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, tatsu, arrow
, pytest-sugar, pytestpep8, pytest-flakes, pytestcov
}:

buildPythonPackage rec {
  pname = "ics";
  version = "0.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "C4ptainCrunch";
    repo = "ics.py";
    rev = "v${version}";
    sha256 = "02bs9wlh40p1n33jchrl2cdpsnm5hq84070by3b6gm0vmgz6gn5v";
  };

  propagatedBuildInputs = [ tatsu arrow ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "arrow>=0.11,<0.15" "arrow"
  '';

  checkInputs = [ pytest-sugar pytestpep8 pytest-flakes pytestcov ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Pythonic and easy iCalendar library (RFC 5545)";
    longDescription = ''
      Ics.py is a pythonic and easy iCalendar library. Its goals are to read and
      write ics data in a developer friendly way.
    '';
    homepage = "http://icspy.readthedocs.org/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };

}
