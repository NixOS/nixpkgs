{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, click
, dateparser
, pandas
, py-lru-cache
, six
, pytest
}:

buildPythonPackage rec {
  pname = "csvs-to-sqlite";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "0js86m4kj70g9n9gagr8l6kgswqllg6hn1xa3yvxwv95i59ihpz5";
  };

  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    click
    dateparser
    pandas
    py-lru-cache
    six
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Convert CSV files into a SQLite database";
    homepage = https://github.com/simonw/csvs-to-sqlite;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
