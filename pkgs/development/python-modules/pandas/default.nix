{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  meson-python,
  meson,
  pkg-config,
  versioneer,
  wheel,

  # propagates
  numpy,
  python-dateutil,
  pytz,
  tzdata,

  # optionals
  beautifulsoup4,
  bottleneck,
  blosc2,
  fsspec,
  gcsfs,
  html5lib,
  jinja2,
  lxml,
  matplotlib,
  numba,
  numexpr,
  odfpy,
  openpyxl,
  psycopg2,
  pyarrow,
  pymysql,
  pyqt5,
  pyreadstat,
  qtpy,
  s3fs,
  scipy,
  sqlalchemy,
  tables,
  tabulate,
  xarray,
  xlrd,
  xlsxwriter,
  zstandard,

  # tests
  adv_cmds,
  glibc,
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  pytest-asyncio,
  python,
  runtimeShell,
}:

let
  pandas = buildPythonPackage rec {
    pname = "pandas";
    version = "2.3.1";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "pandas-dev";
      repo = "pandas";
      tag = "v${version}";
      hash = "sha256-xvdiWjJ5uHfrzXB7c4cYjFjZ6ue5i7qzb4tAEPJMAV0=";
    };

    # A NOTE regarding the Numpy version relaxing: Both Numpy versions 1.x &
    # 2.x are supported. However upstream wants to always build with Numpy 2,
    # and with it to still be able to run with a Numpy 1 or 2. We insist to
    # perform this substitution even though python3.pkgs.numpy is of version 2
    # nowadays, because our ecosystem unfortunately doesn't allow easily
    # separating runtime and build-system dependencies. See also:
    #
    # https://discourse.nixos.org/t/several-comments-about-priorities-and-new-policies-in-the-python-ecosystem/51790
    #
    # Being able to build (& run) with Numpy 1 helps for python environments
    # that override globally the `numpy` attribute to point to `numpy_1`.
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "numpy>=2.0" numpy
    '';

    build-system = [
      cython
      meson-python
      meson
      numpy
      pkg-config
      versioneer
      wheel
    ]
    ++ versioneer.optional-dependencies.toml;

    enableParallelBuilding = true;

    dependencies = [
      numpy
      python-dateutil
      pytz
      tzdata
    ];

    optional-dependencies =
      let
        extras = {
          aws = [ s3fs ];
          clipboard = [
            pyqt5
            qtpy
          ];
          compression = [ zstandard ];
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
          feather = [ pyarrow ];
          fss = [ fsspec ];
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
          parquet = [ pyarrow ];
          performance = [
            bottleneck
            numba
            numexpr
          ];
          plot = [ matplotlib ];
          postgresql = [
            sqlalchemy
            psycopg2
          ];
          spss = [ pyreadstat ];
          sql-other = [ sqlalchemy ];
          xml = [ lxml ];
        };
      in
      extras // { all = lib.concatLists (lib.attrValues extras); };

    doCheck = false; # various infinite recursions

    passthru.tests.pytest = pandas.overridePythonAttrs (_: {
      doCheck = true;
    });

    nativeCheckInputs = [
      hypothesis
      pytest-asyncio
      pytest-xdist
      pytestCheckHook
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies)
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      # for locale executable
      glibc
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # for locale executable
      adv_cmds
    ];

    # don't max out build cores, it breaks tests
    dontUsePytestXdist = true;

    __darwinAllowLocalNetworking = true;

    pytestFlags = [
      # https://github.com/pandas-dev/pandas/issues/54907
      "--no-strict-data-files"
      "--numprocesses=4"
    ];

    disabledTestMarks = [
      # https://github.com/pandas-dev/pandas/blob/main/test_fast.sh
      "single_cpu"
      "slow"
      "network"
      "db"
      "slow_arm"
    ];

    disabledTests = [
      # AssertionError: Did not see expected warning of class 'FutureWarning'
      "test_parsing_tzlocal_deprecated"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # tests/generic/test_finalize.py::test_binops[and_-args4-right] - AssertionError: assert {} == {'a': 1}
      "test_binops"
      # These tests are unreliable on aarch64-darwin. See https://github.com/pandas-dev/pandas/issues/38921.
      "test_rolling"
    ]
    ++ lib.optional stdenv.hostPlatform.is32bit [
      # https://github.com/pandas-dev/pandas/issues/37398
      "test_rolling_var_numerical_issues"
    ];

    # Tests have relative paths, and need to reference compiled C extensions
    # so change directory where `import .test` is able to be resolved
    preCheck = ''
      export HOME=$TMPDIR
      cd $out/${python.sitePackages}/pandas
    ''
    # TODO: Get locale and clipboard support working on darwin.
    #       Until then we disable the tests.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Fake the impure dependencies pbpaste and pbcopy
      echo "#!${runtimeShell}" > pbcopy
      echo "#!${runtimeShell}" > pbpaste
      chmod a+x pbcopy pbpaste
      export PATH=$(pwd):$PATH
    '';

    pythonImportsCheck = [ "pandas" ];

    meta = with lib; {
      # pandas devs no longer test i686, it's commonly broken
      # broken = stdenv.hostPlatform.isi686;
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
      maintainers = with maintainers; [
        raskin
      ];
    };
  };
in
pandas
