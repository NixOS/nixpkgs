{ stdenv, lib
, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm, pytestCheckHook
, aiohttp
, aiohttp-cors
, appdirs
, attrs
, click
, dataclasses
, mypy-extensions
, pathspec
, parameterized
, regex
, toml
, typed-ast
, typing-extensions }:

buildPythonPackage rec {
  pname = "black";
  version = "21.5b1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cdkrl5vw26iy7s23v2zpr39m6g5xsgxhfhagzzflgfbvdc56s93";
  };

  nativeBuildInputs = [ setuptools_scm ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  checkInputs =  [ pytestCheckHook parameterized ];

  preCheck = ''
    export PATH="$PATH:$out/bin"

    # The top directory /build matches black's DEFAULT_EXCLUDE regex.
    # Make /build the project root for black tests to avoid excluding files.
    touch ../.git
  '';

  disabledTests = [
    # requires network access
    "test_gen_check_output"
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
