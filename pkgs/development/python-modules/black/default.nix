{ stdenv, lib
, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm, pytestCheckHook
, aiohttp
, aiohttp-cors
, appdirs
, attrs
, click
, dataclasses
, mypy-extensions
, parameterized
, pathspec
, regex
, toml
, typed-ast
, typing-extensions }:

buildPythonPackage rec {
  pname = "black";
  version = "21.4b0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kV2RbEhkbb6AQNUmXP9xEUIaYKPf5/fgcnMXalfCSjQ=";
  };

  nativeBuildInputs = [ setuptools_scm ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  checkInputs =  [ parameterized pytestCheckHook ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  disabledTests = [
    # Don't know why these tests fails
    "test_cache_multiple_files"
    "test_failed_formatting_does_not_get_cached"
    "test_output_locking_when_writeback_diff"
    "test_output_locking_when_writeback_color_diff"
    # requires network access
    "test_gen_check_output"
    "test_process_queue"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails on darwin
    "test_expression_diff"
  ];

  propagatedBuildInputs = [
    aiohttp
    aiohttp-cors
    appdirs
    attrs
    click
    mypy-extensions
    pathspec
    regex
    toml
    typed-ast
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") dataclasses;

  meta = with lib; {
    description = "The uncompromising Python code formatter";
    homepage    = "https://github.com/psf/black";
    changelog   = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license     = licenses.mit;
    maintainers = with maintainers; [ sveitser ];
  };
}
