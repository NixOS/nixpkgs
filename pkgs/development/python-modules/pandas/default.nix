{ buildPythonPackage
, fetchPypi
, python
, stdenv
, fetchurl
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
  inherit (stdenv.lib) optional optionalString concatStringsSep;
  inherit (stdenv) isDarwin;
in buildPythonPackage rec {
  pname = "pandas";
  version = "0.21.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nf50ls2cnlsd2635nyji7l70xc91dw81qg5y01g5sifwwqcpmaw";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ pytest glibcLocales ] ++ optional isDarwin libcxx;
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

  checkInputs = [ moto ];
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
    # since dateutil 0.6.0 the following fails: test_fallback_plural, test_ambiguous_flags, test_ambiguous_compat
    # was supposed to be solved by https://github.com/dateutil/dateutil/issues/321, but is not the case
    py.test $out/${python.sitePackages}/pandas --skip-slow --skip-network \
      -k "not test_fallback_plural and \
          not test_ambiguous_flags and \
          not test_ambiguous_compat \
          ${optionalString isDarwin "and not test_locale and not test_clipboard"}"
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
