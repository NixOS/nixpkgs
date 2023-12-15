{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython
, meson-python
, meson
, oldest-supported-numpy
, pkg-config
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
}:

buildPythonPackage rec {
  pname = "pandas";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pandas-dev";
    repo = "pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-6SgW4BtO7EFnS8P8LL4AGk5EdPwOQ0+is0wXgqsm9w0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "meson-python==0.13.1" "meson-python>=0.13.1" \
      --replace "meson==1.2.1" "meson>=1.2.1"
  '';

  nativeBuildInputs = [
    cython
    meson-python
    meson
    numpy
    pkg-config
    versioneer
    wheel
  ]
  ++ versioneer.optional-dependencies.toml
  ++ lib.optionals (pythonOlder "3.12") [
    oldest-supported-numpy
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    numpy
    python-dateutil
    pytz
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

  pytestFlagsArray = [
    # https://github.com/pandas-dev/pandas/blob/main/test_fast.sh
    "-m" "'not single_cpu and not slow and not network and not db and not slow_arm'"
    # https://github.com/pandas-dev/pandas/issues/54907
    "--no-strict-data-files"
    "--numprocesses" "4"
  ];

  disabledTests = [
    # AssertionError: Did not see expected warning of class 'FutureWarning'
    "test_parsing_tzlocal_deprecated"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # tests/generic/test_finalize.py::test_binops[and_-args4-right] - AssertionError: assert {} == {'a': 1}
    "test_binops"
    # These tests are unreliable on aarch64-darwin. See https://github.com/pandas-dev/pandas/issues/38921.
    "test_rolling"
  ] ++ lib.optional stdenv.is32bit [
    # https://github.com/pandas-dev/pandas/issues/37398
    "test_rolling_var_numerical_issues"
  ];

  # Tests have relative paths, and need to reference compiled C extensions
  # so change directory where `import .test` is able to be resolved
  preCheck = ''
    export HOME=$TMPDIR
    export LC_ALL="en_US.UTF-8"
    cd $out/${python.sitePackages}/pandas
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

  pythonImportsCheck = [
    "pandas"
  ];

  meta = with lib; {
    # pandas devs no longer test i686, it's commonly broken
    # broken = stdenv.isi686;
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
  };
}
