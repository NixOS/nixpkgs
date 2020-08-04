{ buildPythonPackage
, fetchPypi
, python
, stdenv
, pytest
, glibcLocales
, cython
, dateutil
, scipy
, moto
, numexpr
, pytz
, xlrd
, bottleneck
, sqlalchemy
, lxml
, html5lib
, beautifulsoup4
, hypothesis
, openpyxl
, tables
, xlwt
, runtimeShell
, isPy38
, libcxx ? null
}:

let
  inherit (stdenv.lib) optional optionals optionalString;
  inherit (stdenv) isDarwin;

in buildPythonPackage rec {
  pname = "pandas";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69c5d920a0b2a9838e677f78f4dde506b95ea8e4d30da25859db6469ded84fa8";
  };

  checkInputs = [ pytest glibcLocales moto hypothesis ];

  nativeBuildInputs = [ cython ];
  buildInputs = optional isDarwin libcxx;
  propagatedBuildInputs = [
    dateutil
    scipy
    numexpr
    pytz
    xlrd
    bottleneck
    sqlalchemy
    lxml
    html5lib
    beautifulsoup4
    openpyxl
    tables
    xlwt
  ];

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


  disabledTests = stdenv.lib.concatMapStringsSep " and " (s: "not " + s) ([
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
  ] ++ optionals isDarwin [
    "test_locale"
    "test_clipboard"
  ]);

  doCheck = !stdenv.isAarch64; # upstream doesn't test this architecture

  checkPhase = ''
    runHook preCheck
  ''
  # TODO: Get locale and clipboard support working on darwin.
  #       Until then we disable the tests.
  + optionalString isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    echo "#!${runtimeShell}" > pbcopy
    echo "#!${runtimeShell}" > pbpaste
    chmod a+x pbcopy pbpaste
    export PATH=$(pwd):$PATH
  '' + ''
    LC_ALL="en_US.UTF-8" py.test $out/${python.sitePackages}/pandas --skip-slow --skip-network -k "$disabledTests"
    runHook postCheck
  '';

  meta = {
    # https://github.com/pandas-dev/pandas/issues/14866
    # pandas devs are no longer testing i686 so safer to assume it's broken
    broken = stdenv.isi686;
    homepage = "https://pandas.pydata.org/";
    description = "Python Data Analysis Library";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ raskin fridh knedlsepp ];
    platforms = stdenv.lib.platforms.unix;
  };
}
