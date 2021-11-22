{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-runner
, dictdiffer
, click
}:

buildPythonPackage rec {
  pname = "csv-diff";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1skbaxgn72qlpl8pmmmihpzlb28rvks78wwi9yydhzf6j9wi357z";
  };

  propagatedBuildInputs = [
    dictdiffer
    click
  ];

  checkInputs = [
    pytest
    pytest-runner
  ];

  meta = with lib; {
    description = "Tool for viewing the difference between two CSV, TSV or JSON files";
    homepage = "https://github.com/simonw/csv-diff";
    license = licenses.asl20;
    maintainer = with maintainers; [ turion ];
  };
}
