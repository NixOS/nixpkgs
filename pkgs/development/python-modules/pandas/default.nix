{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, cython
, numpy
, python-dateutil
, pytz
, scipy
, sqlalchemy
, tables
, xlrd
, xlwt
# Test inputs
, glibcLocales
, hypothesis
, jinja2
, pytestCheckHook
, pytest-xdist
, pytest-asyncio
, XlsxWriter
# Darwin inputs
, runtimeShell
, libcxx
}:

buildPythonPackage rec {
  pname = "pandas";
  version = "1.5.2";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IguY0VzuCyzYOaY1i9Hyc9A1a/lkwaGusy1H2wIVSIs=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = lib.optional stdenv.isDarwin libcxx;

  propagatedBuildInputs = [
    numpy
    python-dateutil
    pytz
  ];

  checkInputs = [
    glibcLocales
    hypothesis
    jinja2
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    XlsxWriter
  ];

  # Doesn't work with -Werror,-Wunused-command-line-argument
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  doCheck = !stdenv.isAarch32 && !stdenv.isAarch64; # upstream doesn't test this architecture

  # don't max out build cores, it breaks tests
  dontUsePytestXdist = true;

  pytestFlagsArray = [
    # https://github.com/pandas-dev/pandas/blob/main/test_fast.sh
    "--skip-db"
    "--skip-slow"
    "--skip-network"
    "-m" "'not single_cpu'"
    "--numprocesses" "4"
  ];

  disabledTests = [
    # Locale-related
    "test_names"
    "test_dt_accessor_datetime_name_accessors"
    "test_datetime_name_accessors"
    # Disable IO related tests because IO data is no longer distributed
    "io"
    # Tries to import from pandas.tests post install
    "util_in_top_level"
    # Tries to import compiled C extension locally
    "test_missing_required_dependency"
    # AssertionError with 1.2.3
    "test_from_coo"
    # AssertionError: No common DType exists for the given inputs
    "test_comparison_invalid"
    # AssertionError: Regex pattern '"quotechar" must be string, not int'
    "python-kwargs2"
    # Tests for rounding errors and fails if we have better precision
    # than expected, e.g. on amd64 with FMA or on arm64
    # https://github.com/pandas-dev/pandas/issues/38921
    "test_rolling_var_numerical_issues"
    # Requires mathplotlib
    "test_subset_for_boolean_cols"
    # DeprecationWarning from numpy
    "test_sort_values_sparse_no_warning"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_locale"
    "test_clipboard"
    # ValueError: cannot reindex on an axis with duplicate labels
    #
    # Attempts to reproduce this problem outside of Hydra failed.
    "test_reindex_timestamp_with_fold"
  ];

  # Tests have relative paths, and need to reference compiled C extensions
  # so change directory where `import .test` is able to be resolved
  preCheck = ''
    cd $out/${python.sitePackages}/pandas
    export LC_ALL="en_US.UTF-8"
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  ''
  # TODO: Get locale and clipboard support working on darwin.
  #       Until then we disable the tests.
  + lib.optionalString stdenv.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    echo "#!${runtimeShell}" > pbcopy
    echo "#!${runtimeShell}" > pbpaste
    chmod a+x pbcopy pbpaste
    export PATH=$(pwd):$PATH
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pandas" ];

  meta = with lib; {
    # https://github.com/pandas-dev/pandas/issues/14866
    # pandas devs are no longer testing i686 so safer to assume it's broken
    broken = stdenv.isi686;
    homepage = "https://pandas.pydata.org/";
    changelog = "https://pandas.pydata.org/docs/whatsnew/index.html";
    description = "Python Data Analysis Library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin fridh knedlsepp ];
    platforms = platforms.unix;
  };
}
