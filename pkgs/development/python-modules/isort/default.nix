{ lib, buildPythonPackage, fetchPypi, isPy27, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "isort";
  version = "4.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y0yfv56cqyh9wyg7kxxv9y5wmfgcq18n7a49mp7xmzka2bhxi5r";
  };

  propagatedBuildInputs = lib.optional isPy27 futures;

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test_isort.py -k "not test_long_line_comments \
                          and not test_import_case_produces_inconsistent_results_issue_472 \
                          and not test_no_extra_lines_issue_557"
  '';

  meta = with lib; {
    description = "A Python utility / library to sort Python imports";
    homepage = https://github.com/timothycrosley/isort;
    license = licenses.mit;
    maintainers = with maintainers; [ couchemar nand0p ];
  };
}
