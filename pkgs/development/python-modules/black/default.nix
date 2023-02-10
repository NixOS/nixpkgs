{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, aiohttp
, aiohttp-cors
, click
, colorama
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, mypy-extensions
, pathspec
, parameterized
, platformdirs
, tomli
, typed-ast
, typing-extensions
, uvloop
}:

buildPythonPackage rec {
  pname = "black";
  version = "22.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IpNR5aGMow9Ee/ck0Af4kPl+E68HC7atTApEHNdZai8=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook parameterized aiohttp ];

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
  # multiple tests exceed max open files on hydra builders
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  propagatedBuildInputs = [
    click
    mypy-extensions
    pathspec
    platformdirs
    tomli
  ] ++ lib.optional (pythonOlder "3.8") typed-ast
  ++ lib.optional (pythonOlder "3.10") typing-extensions;

  passthru.optional-dependencies = {
    d = [ aiohttp aiohttp-cors ];
    colorama = [ colorama ];
    uvloop = [ uvloop ];
  };

  meta = with lib; {
    description = "The uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sveitser autophagy ];
  };
}
