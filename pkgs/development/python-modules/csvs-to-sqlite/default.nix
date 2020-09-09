{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
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
  version = "1.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "1xi9d8l1sf9vixzvqpz8lvhl6yqmz9x5659nvpsxinl317qzmc8m";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pandas~=0.25.0 pandas
  '';

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
    homepage = "https://github.com/simonw/csvs-to-sqlite";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
