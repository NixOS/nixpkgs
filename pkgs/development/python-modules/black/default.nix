{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  aiohttp,
  click,
  colorama,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  ipython,
  mypy-extensions,
  packaging,
  pathspec,
  parameterized,
  platformdirs,
  pytokens,
  tokenize-rt,
  uvloop,
}:

buildPythonPackage rec {
  pname = "black";
  version = "26.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3TIfZoBTlhgkvMG+HMHfdIstfk+igIawgzHld7AQCnM=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    click
    mypy-extensions
    packaging
    pathspec
    platformdirs
    pytokens
  ];

  optional-dependencies = {
    colorama = [ colorama ];
    d = [ aiohttp ];
    uvloop = [ uvloop ];
    jupyter = [
      ipython
      tokenize-rt
    ];
  };

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"

    # The top directory /build matches black's DEFAULT_EXCLUDE regex.
    # Make /build the project root for black tests to avoid excluding files.
    touch ../.git
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Work around https://github.com/psf/black/issues/2105
    export TMPDIR="/tmp"
  '';

  disabledTests = [
    # requires network access
    "test_gen_check_output"
    # broken on Python 3.13.4
    # FIXME: remove this when fixed upstream
    "test_simple_format[pep_701]"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails on darwin
    "test_expression_diff"
    # Fail on Hydra, see https://github.com/NixOS/nixpkgs/pull/130785
    "test_bpo_2142_workaround"
    "test_skip_magic_trailing_comma"
  ];
  # multiple tests exceed max open files on hydra builders
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  meta = {
    description = "Uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    mainProgram = "black";
    maintainers = with lib.maintainers; [
      sveitser
      autophagy
    ];
  };
}
