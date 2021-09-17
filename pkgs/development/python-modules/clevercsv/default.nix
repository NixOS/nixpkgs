{ lib
, buildPythonPackage
, fetchFromGitHub
, chardet
, cleo
, clikit
, pandas
, regex
, tabview
, python
}:

buildPythonPackage rec {
  pname = "clevercsv";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    rev = "v${version}";
    sha256 = "09ccgydnrfdgxjz6ph829l9q62jkzqrak0k6yjik2rvs33jn0dhc";
  };

  propagatedBuildInputs = [
    chardet
    cleo
    clikit
    pandas
    regex
    tabview
  ];

  pythonImportsCheck = [
    "clevercsv"
    "clevercsv.cparser"
  ];

  checkPhase = ''
    # by linking the installed version the tests also have access to compiled native libraries
    rm -r clevercsv
    ln -s $out/${python.sitePackages}/clevercsv/ clevercsv
    # their ci only runs unit tests, there are also integration and fuzzing tests
    ${python.interpreter} -m unittest discover -v -f -s ./tests/test_unit
  '';

  meta = with lib; {
    description = "CleverCSV is a Python package for handling messy CSV files";
    longDescription = ''
       CleverCSV is a Python package for handling messy CSV files. It provides
       a drop-in replacement for the builtin CSV module with improved dialect
       detection, and comes with a handy command line application for working
       with CSV files.
    '';
    homepage = "https://github.com/alan-turing-institute/CleverCSV";
    changelog = "https://github.com/alan-turing-institute/CleverCSV/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
