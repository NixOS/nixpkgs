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
, openpyxl
, tables
, xlwt
, libcxx ? null
}:

let
  inherit (stdenv.lib) optional optionals optionalString;
  inherit (stdenv) isDarwin;

in buildPythonPackage rec {
  pname = "pandas";
  version = "0.23.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50b52af2af2e15f4aeb2fe196da073a8c131fa02e433e105d95ce40016df5690";
  };

  LC_ALL = "en_US.UTF-8";

  checkInputs = [ pytest glibcLocales moto ];

  buildInputs = [] ++ optional isDarwin libcxx;
  propagatedBuildInputs = [
    cython
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
  ] ++ optionals isDarwin [
    "test_locale"
    "test_clipboard"
  ]);

  checkPhase = ''
    runHook preCheck
  ''
  # TODO: Get locale and clipboard support working on darwin.
  #       Until then we disable the tests.
  + optionalString isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    echo "#!/bin/sh" > pbcopy
    echo "#!/bin/sh" > pbpaste
    chmod a+x pbcopy pbpaste
    export PATH=$(pwd):$PATH
  '' + ''
    py.test $out/${python.sitePackages}/pandas --skip-slow --skip-network -k "$disabledTests"
    runHook postCheck
  '';

  meta = {
    # https://github.com/pandas-dev/pandas/issues/14866
    # pandas devs are no longer testing i686 so safer to assume it's broken
    broken = stdenv.isi686;
    homepage = http://pandas.pydata.org/;
    description = "Python Data Analysis Library";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ raskin fridh knedlsepp ];
    platforms = stdenv.lib.platforms.unix;
  };
}
