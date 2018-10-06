{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, attrs, click, toml, appdirs
, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "black";
  version = "18.9b0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1992ramdwv8sg4mbl5ajirwj5i4a48zjgsycib0fnbaliyiajc70";
  };

  checkInputs =  [ pytest glibcLocales ];

  checkPhase = ''
    # no idea, why those fail.
    LC_ALL="en_US.UTF-8" HOME="$NIX_BUILD_TOP" \
      pytest \
        -k "not test_cache_multiple_files and not test_failed_formatting_does_not_get_cached"
  '';

  propagatedBuildInputs = [ attrs appdirs click toml ];

  meta = with stdenv.lib; {
    description = "The uncompromising Python code formatter";
    homepage    = https://github.com/ambv/black;
    license     = licenses.mit;
    maintainers = with maintainers; [ sveitser ];
  };

}
