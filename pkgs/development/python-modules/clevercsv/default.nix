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
  version = "0.6.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    rev = "v${version}";
    sha256 = "0j3959bji48pkp0vnk7yls5l75ywjl77jdkvzs62n5mi5lky88p9";
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
