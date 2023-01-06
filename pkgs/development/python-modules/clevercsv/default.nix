{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cchardet
, chardet
, pandas
, regex
, tabview
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clevercsv";
  version = "0.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    rev = "refs/tags/v${version}";
    hash = "sha256-2OLvVJbqV/wR+Quq0cAlR/vCUe1/Km/nALwfoHD9B+U=";
  };

  patches = [
    (fetchpatch {
      # Fixes compat with setuptools>=65.6.0
      # https://github.com/alan-turing-institute/CleverCSV/issues/77
      url = "https://github.com/alan-turing-institute/CleverCSV/commit/0614fe16fa0e8e08c4c916efc956209fe2aa8ce6.patch";
      hash = "sha256-ZL0cc5Si8ga6kd3JhfaIUOWXdnEgep9tvHBVpXjsI+w=";
    })
  ];

  propagatedBuildInputs = [
    cchardet
    chardet
    pandas
    regex
    tabview
  ];

  checkInputs = [
    pytestCheckHook
  ];

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
  pytestFlagsArray = [
    "./tests/test_unit"
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'wilderness'
    "tests/test_unit/test_console.py"
  ];

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
