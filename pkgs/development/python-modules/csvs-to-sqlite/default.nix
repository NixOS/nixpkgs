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
  version = "1.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "0p99cg76d3s7jxvigh5ad04dzhmr6g62qzzh4i6h7x9aiyvdhvk4";
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
