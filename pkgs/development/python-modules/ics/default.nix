{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, tatsu, arrow
, pytest-sugar, pytestpep8, pytest-flakes, pytestcov
}:

buildPythonPackage rec {
  pname = "ics";
  version = "0.7";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "C4ptainCrunch";
    repo = "ics.py";
    rev = "v${version}";
    sha256 = "0rrdc9rcxc3ys6rml81b8m8qdlisk78a34bdib0wy65hlkmyyykn";
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
    changelog = "https://github.com/C4ptainCrunch/ics.py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };

}
