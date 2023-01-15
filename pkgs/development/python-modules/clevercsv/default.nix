{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.7.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    rev = "refs/tags/v${version}";
    hash = "sha256-zpnUw0ThYbbYS7CYgsi0ZL1qxbY4B1cy2NhrUU9uzig=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "packaging>=23.0" "packaging"
  '';

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
