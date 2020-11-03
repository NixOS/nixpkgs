{ stdenv
, buildPythonPackage
, fetchPypi
, python
, isPy38
, beautifulsoup4
, bottleneck
, cython
, dateutil
, html5lib
, lxml
, numexpr
, openpyxl
, pytz
, sqlalchemy
, scipy
, tables
, xlrd
, xlwt
# Test Inputs
, glibcLocales
, hypothesis
, moto
, pytestCheckHook
# Darwin inputs
, runtimeShell
, libcxx ? null
}:

let
  inherit (stdenv.lib) optional optionals optionalString;
  inherit (stdenv) isDarwin;

in buildPythonPackage rec {
  pname = "pandas";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a979d0404b135c63954dea79e6246c45dd45371a88631cdbb4877d844e6de3b6";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = optional isDarwin libcxx;
  requiredPythonModules = [
    beautifulsoup4
    bottleneck
    dateutil
    html5lib
    numexpr
    lxml
    openpyxl
    pytz
    scipy
    sqlalchemy
    tables
    xlrd
    xlwt
  ];

  checkInputs = [ pytestCheckHook glibcLocales moto hypothesis ];

  # doesn't work with -Werror,-Wunused-command-line-argument
  # https://github.com/NixOS/nixpkgs/issues/39687
  hardeningDisable = optional stdenv.cc.isClang "strictoverflow";

  # For OSX, we need to add a dependency on libcxx, which provides
  # `complex.h` and other libraries that pandas depends on to build.
  postPatch = optionalString isDarwin ''
    cpp_sdk="${libcxx}/include/c++/v1";
    echo "Adding $cpp_sdk to the setup.py common_include variable"
    substituteInPlace setup.py \
      --replace "['pandas/src/klib', 'pandas/src']" \
                "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"
  '';

  # Parallel Cythonization is broken in Python 3.8 on Darwin. Fixed in the next
  # release. https://github.com/pandas-dev/pandas/pull/30862
  setupPyBuildFlags = optionals (!(isPy38 && isDarwin)) [
    # As suggested by
    # https://pandas.pydata.org/pandas-docs/stable/development/contributing.html#creating-a-python-environment
    "--parallel=$NIX_BUILD_CORES"
  ];

  doCheck = !stdenv.isAarch64; # upstream doesn't test this architecture

  pytestFlagsArray = [
    "$out/${python.sitePackages}/pandas"
    "--skip-slow"
    "--skip-network"
  ];
  disabledTests = [
    # since dateutil 0.6.0 the following fails: test_fallback_plural, test_ambiguous_flags, test_ambiguous_compat
    # was supposed to be solved by https://github.com/dateutil/dateutil/issues/321, but is not the case
    "test_fallback_plural"
    "test_ambiguous_flags"
    "test_ambiguous_compat"
    # Locale-related
    "test_names"
    "test_dt_accessor_datetime_name_accessors"
    "test_datetime_name_accessors"
    # Can't import from test folder
    "test_oo_optimizable"
    # Disable IO related tests because IO data is no longer distributed
    "io"
    # KeyError Timestamp
    "test_to_excel"
    # ordering logic has changed
    "numpy_ufuncs_other"
    "order_without_freq"
    # tries to import from pandas.tests post install
    "util_in_top_level"
    # Fails with 1.0.5
    "test_constructor_list_frames"
    "test_constructor_with_embedded_frames"
    # tries to import compiled C extension locally
    "test_missing_required_dependency"
  ] ++ optionals isDarwin [
    "test_locale"
    "test_clipboard"
  ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  ''
  # TODO: Get locale and clipboard support working on darwin.
  #       Until then we disable the tests.
  + optionalString isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    echo "#!${runtimeShell}" > pbcopy
    echo "#!${runtimeShell}" > pbpaste
    chmod a+x pbcopy pbpaste
    export PATH=$(pwd):$PATH
  '';

  meta = with stdenv.lib; {
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
