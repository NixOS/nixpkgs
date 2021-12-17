{ stdenv, lib
, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm, pytestCheckHook
, aiohttp
, aiohttp-cors
, attrs
, click
, colorama
, dataclasses
, mypy-extensions
, pathspec
, parameterized
, platformdirs
, regex
, tomli
, typed-ast
, typing-extensions
, uvloop
}:


buildPythonPackage rec {
  pname = "black";
  version = "21.10b0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qZUiKQkuMl/l89rlbYH2ObI/cTHrhAeBlH5LKIYDDzM=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  checkInputs = [ pytestCheckHook parameterized ];

  preCheck = ''
    export PATH="$PATH:$out/bin"

    # The top directory /build matches black's DEFAULT_EXCLUDE regex.
    # Make /build the project root for black tests to avoid excluding files.
    touch ../.git
  '' + lib.optionalString stdenv.isDarwin ''
    # Work around https://github.com/psf/black/issues/2105
    export TMPDIR="/tmp"
  '';

  disabledTests = [
    # requires network access
    "test_gen_check_output"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails on darwin
    "test_expression_diff"
    # Fail on Hydra, see https://github.com/NixOS/nixpkgs/pull/130785
    "test_bpo_2142_workaround"
    "test_skip_magic_trailing_comma"
  ];

  propagatedBuildInputs = [
    aiohttp
    aiohttp-cors
    attrs
    click
    colorama
    mypy-extensions
    pathspec
    platformdirs
    regex
    tomli
    typed-ast # required for tests and python2 extra
    uvloop
  ] ++ lib.optional (pythonOlder "3.7") dataclasses
    ++ lib.optional (pythonOlder "3.8") typing-extensions;

  meta = with lib; {
    description = "The uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sveitser autophagy ];
  };
}
