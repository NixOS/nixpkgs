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
, darwin ? {}
, libcxx ? null
}:

let
  inherit (stdenv.lib) optional optionalString concatStringsSep;
  inherit (stdenv) isDarwin;
in buildPythonPackage rec {
  pname = "pandas";
  version = "0.20.0rc1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a914f8a31f24e6225fa3c777e8ec2fbc83ca97e99911bfc695758569aceb2356";
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
  ] ++ optional isDarwin darwin.locale; # provides the locale command

  # For OSX, we need to add a dependency on libcxx, which provides
  # `complex.h` and other libraries that pandas depends on to build.
  patchPhase = optionalString isDarwin ''
    cpp_sdk="${libcxx}/include/c++/v1";
    echo "Adding $cpp_sdk to the setup.py common_include variable"
    substituteInPlace setup.py \
      --replace "['pandas/src/klib', 'pandas/src']" \
                "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"

  # disable clipboard tests since pbcopy/pbpaste are not open source
    substituteInPlace pandas/io/tests/test_clipboard.py \
      --replace pandas.util.clipboard no_such_module \
      --replace OSError ImportError
  '';

  # The flag `-A 'not network'` will disable tests that use internet.
  # The `-e` flag disables a few problematic tests.

  checkPhase = ''
    runHook preCheck
    # The flag `-w` provides the initial directory to search for tests.
    # The flag `-A 'not network'` will disable tests that use internet.
    py.test $out/${python.sitePackages}/pandas
    #nosetests -w $out/${python.sitePackages}/pandas --no-path-adjustment -A 'not slow and not network' --stop \
    #  --verbosity=3
     runHook postCheck
  '';

  meta = {
    # https://github.com/pandas-dev/pandas/issues/14866
    # pandas devs are no longer testing i686 so safer to assume it's broken
    broken = stdenv.isi686;
    homepage = "http://pandas.pydata.org/";
    description = "Python Data Analysis Library";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ raskin fridh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
