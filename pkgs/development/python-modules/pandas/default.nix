{ lib
, stdenv
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder

# build-system
, cython
, oldest-supported-numpy
, setuptools
, versioneer
, wheel

# propagates
, numpy
, python-dateutil
, pytz
, tzdata

# optionals
, beautifulsoup4
, bottleneck
, blosc2
, brotlipy
, fsspec
, gcsfs
, html5lib
, jinja2
, lxml
, matplotlib
, numba
, numexpr
, odfpy
, openpyxl
, psycopg2
, pyarrow
, pymysql
, pyqt5
, pyreadstat
, python-snappy
, qtpy
, s3fs
, scipy
, sqlalchemy
, tables
, tabulate
, xarray
, xlrd
, xlsxwriter
, zstandard

# tests
, adv_cmds
, glibc
, glibcLocales
, hypothesis
, pytestCheckHook
, pytest-xdist
, pytest-asyncio
, python
, runtimeShell
=======
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
, xlsxwriter
# Darwin inputs
, runtimeShell
, libcxx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pandas";
<<<<<<< HEAD
  version = "2.0.3";
  format = "pyproject";

=======
  version = "1.5.3";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-wC83Kojg0X820wk6ZExzz8F4jodqfEvLQCCndRLiBDw=";
  };

  nativeBuildInputs = [
    setuptools
    cython
    numpy
    oldest-supported-numpy
    versioneer
    wheel
  ] ++ versioneer.optional-dependencies.toml;

  enableParallelBuilding = true;
=======
    hash = "sha256-dKP9flp+wFLxgyc9x7Cs06hj7fdSD106F2XAT/2zsLE=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = lib.optional stdenv.isDarwin libcxx;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    numpy
    python-dateutil
    pytz
<<<<<<< HEAD
    tzdata
  ];

  passthru.optional-dependencies = let
    extras = {
      aws = [
        s3fs
      ];
      clipboard = [
        pyqt5
        qtpy
      ];
      compression = [
        brotlipy
        python-snappy
        zstandard
      ];
      computation = [
        scipy
        xarray
      ];
      excel = [
        odfpy
        openpyxl
        # TODO: pyxlsb
        xlrd
        xlsxwriter
      ];
      feather = [
        pyarrow
      ];
      fss = [
        fsspec
      ];
      gcp = [
        gcsfs
        # TODO: pandas-gqb
      ];
      hdf5 = [
        blosc2
        tables
      ];
      html = [
        beautifulsoup4
        html5lib
        lxml
      ];
      mysql = [
        sqlalchemy
        pymysql
      ];
      output_formatting = [
        jinja2
        tabulate
      ];
      parquet = [
        pyarrow
      ];
      performance = [
        bottleneck
        numba
        numexpr
      ];
      plot = [
        matplotlib
      ];
      postgresql = [
        sqlalchemy
        psycopg2
      ];
      spss = [
        pyreadstat
      ];
      sql-other = [
        sqlalchemy
      ];
      xml = [
        lxml
      ];
    };
  in extras // {
    all = lib.concatLists (lib.attrValues extras);
  };

  nativeCheckInputs = [
    glibcLocales
    hypothesis
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ] ++ lib.optionals (stdenv.isLinux) [
    # for locale executable
    glibc
  ] ++ lib.optionals (stdenv.isDarwin) [
    # for locale executable
    adv_cmds
  ];

  # don't max out build cores, it breaks tests
  dontUsePytestXdist = true;

  __darwinAllowLocalNetworking = true;

=======
  ];

  nativeCheckInputs = [
    glibcLocales
    # hypothesis indirectly depends on pandas to build its documentation
    (hypothesis.override { enableDocumentation = false; })
    jinja2
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    xlsxwriter
  ];

  # Doesn't work with -Werror,-Wunused-command-line-argument
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  doCheck = !stdenv.isAarch32 && !stdenv.isAarch64; # upstream doesn't test this architecture

  # don't max out build cores, it breaks tests
  dontUsePytestXdist = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pytestFlagsArray = [
    # https://github.com/pandas-dev/pandas/blob/main/test_fast.sh
    "--skip-db"
    "--skip-slow"
    "--skip-network"
<<<<<<< HEAD
    "-m" "'not single_cpu and not slow_arm'"
=======
    "-m" "'not single_cpu'"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--numprocesses" "4"
  ];

  disabledTests = [
<<<<<<< HEAD
    # AssertionError: Did not see expected warning of class 'FutureWarning'
    "test_parsing_tzlocal_deprecated"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # tests/generic/test_finalize.py::test_binops[and_-args4-right] - AssertionError: assert {} == {'a': 1}
    "test_binops"
    # These tests are unreliable on aarch64-darwin. See https://github.com/pandas-dev/pandas/issues/38921.
    "test_rolling"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Tests have relative paths, and need to reference compiled C extensions
  # so change directory where `import .test` is able to be resolved
  preCheck = ''
<<<<<<< HEAD
    export HOME=$TMPDIR
    export LC_ALL="en_US.UTF-8"
    cd $out/${python.sitePackages}/pandas
=======
    cd $out/${python.sitePackages}/pandas
    export LC_ALL="en_US.UTF-8"
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "pandas"
  ];
=======
  enableParallelBuilding = true;

  pythonImportsCheck = [ "pandas" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    # https://github.com/pandas-dev/pandas/issues/14866
    # pandas devs are no longer testing i686 so safer to assume it's broken
    broken = stdenv.isi686;
<<<<<<< HEAD
    changelog = "https://pandas.pydata.org/docs/whatsnew/index.html";
    description = "Powerful data structures for data analysis, time series, and statistics";
    downloadPage = "https://github.com/pandas-dev/pandas";
    homepage = "https://pandas.pydata.org";
    license = licenses.bsd3;
    longDescription = ''
      Flexible and powerful data analysis / manipulation library for
      Python, providing labeled data structures similar to R data.frame
      objects, statistical functions, and much more.
    '';
    maintainers = with maintainers; [ raskin fridh knedlsepp ];
=======
    homepage = "https://pandas.pydata.org/";
    changelog = "https://pandas.pydata.org/docs/whatsnew/index.html";
    description = "Python Data Analysis Library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin fridh knedlsepp ];
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
