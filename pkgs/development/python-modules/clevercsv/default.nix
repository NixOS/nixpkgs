{ lib
, buildPythonPackage
, fetchFromGitHub
, cchardet
, chardet
, cleo
, clikit
, pandas
, regex
, tabview
, python
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "clevercsv";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    rev = "v${version}";
    sha256 = "sha256-ynS3G2ZcEqVlC2d6n5ZQ1Em5lh/dWESj9jEO8C4WzZQ=";
  };

  propagatedBuildInputs = [
    cchardet
    chardet
    cleo
    clikit
    pandas
    regex
    tabview
  ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "clevercsv"
    "clevercsv.cparser"
  ];

  preCheck = ''
    # by linking the installed version the tests also have access to compiled native libraries
    rm -r clevercsv
    ln -s $out/${python.sitePackages}/clevercsv/ clevercsv
  '';

  # their ci only runs unit tests, there are also integration and fuzzing tests
  unittestFlagsArray = [ "-v" "-f" "-s" "./tests/test_unit" ];

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
