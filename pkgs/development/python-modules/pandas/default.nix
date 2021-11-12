{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python
, isPy38
, beautifulsoup4
, bottleneck
, cython
, python-dateutil
, html5lib
, jinja2
, lxml
, numexpr
, openpyxl
, pytz
, scipy
, sqlalchemy
, tables
, xlrd
, xlwt
# Test inputs
, glibcLocales
, hypothesis
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
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "272c8cb14aa9793eada6b1ebe81994616e647b5892a370c7135efb2924b701df";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = lib.optional stdenv.isDarwin libcxx;

  propagatedBuildInputs = [
    beautifulsoup4
    bottleneck
    python-dateutil
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

  # For OSX, we need to add a dependency on libcxx, which provides
  # `complex.h` and other libraries that pandas depends on to build.
  postPatch = lib.optionalString stdenv.isDarwin ''
    cpp_sdk="${lib.getDev libcxx}/include/c++/v1";
    echo "Adding $cpp_sdk to the setup.py common_include variable"
    substituteInPlace setup.py \
      --replace "['pandas/src/klib', 'pandas/src']" \
                "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"
  '';

  doCheck = !stdenv.isAarch64; # upstream doesn't test this architecture

  pytestFlagsArray = [
    "--skip-slow"
    "--skip-network"
    "--numprocesses" "0"
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
  ] ++ lib.optionals stdenv.isDarwin [
    "test_locale"
    "test_clipboard"
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
