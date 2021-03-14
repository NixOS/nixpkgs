{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, click
, dateparser
, pandas
, py-lru-cache
, six
, pytestCheckHook
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

  propagatedBuildInputs = [
    click
    dateparser
    pandas
    py-lru-cache
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Convert CSV files into a SQLite database";
    homepage = "https://github.com/simonw/csvs-to-sqlite";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
