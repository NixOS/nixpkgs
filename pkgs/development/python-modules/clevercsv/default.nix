{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  chardet,
  regex,
  packaging,

  # optionals
  faust-cchardet,
  pandas,
  tabview,
  # TODO: , wilderness

  # tests
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "clevercsv";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "CleverCSV";
    tag = "v${version}";
    hash = "sha256-yp102f0WHu9wdVpXBIXn4lP7fi1UOQdA7M11hyVyRyM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chardet
    regex
    packaging
  ];

  optional-dependencies = {
    full = [
      faust-cchardet
      pandas
      tabview
      # TODO: wilderness
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.full;

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
  enabledTestPaths = [ "./tests/test_unit" ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'wilderness'
    "tests/test_unit/test_console.py"
  ];

  meta = with lib; {
    description = "Python package for handling messy CSV files";
    mainProgram = "clevercsv";
    longDescription = ''
      CleverCSV is a Python package for handling messy CSV files. It provides
      a drop-in replacement for the builtin CSV module with improved dialect
      detection, and comes with a handy command line application for working
      with CSV files.
    '';
    homepage = "https://github.com/alan-turing-institute/CleverCSV";
    changelog = "https://github.com/alan-turing-institute/CleverCSV/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
