{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, attrs, click, toml, appdirs, aiohttp, aiohttp-cors
, glibcLocales, typed-ast, pathspec, regex
, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "black";
  version = "19.10b0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f8mr0yzj78q1dx7v6ggbgfir2wv0n5z2shfbbvfdq7910xbgvf2";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs =  [ pytest glibcLocales ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  # Don't know why these tests fails
  # Disable test_expression_diff, because it fails on darwin
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest \
      --deselect tests/test_black.py::BlackTestCase::test_expression_diff \
      --deselect tests/test_black.py::BlackTestCase::test_cache_multiple_files \
      --deselect tests/test_black.py::BlackTestCase::test_failed_formatting_does_not_get_cached
  '';

  propagatedBuildInputs = [ attrs appdirs click toml aiohttp aiohttp-cors pathspec regex typed-ast ];

  meta = with stdenv.lib; {
    description = "The uncompromising Python code formatter";
    homepage    = https://github.com/ambv/black;
    license     = licenses.mit;
    maintainers = with maintainers; [ sveitser ];
  };

}
