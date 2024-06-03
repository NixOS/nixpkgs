{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
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
  tokenize-rt,
  tomli,
  typing-extensions,
  uvloop,
}:

buildPythonPackage rec {
  pname = "black";
  version = "24.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Htp/aIFeDZ+rrvWcP+PxlOrGB4f+V2ESX+fog59BkE=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs =
    [
      click
      mypy-extensions
      packaging
      pathspec
      platformdirs
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      tomli
      typing-extensions
    ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  preCheck =
    ''
      export PATH="$PATH:$out/bin"

      # The top directory /build matches black's DEFAULT_EXCLUDE regex.
      # Make /build the project root for black tests to avoid excluding files.
      touch ../.git
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Work around https://github.com/psf/black/issues/2105
      export TMPDIR="/tmp"
    '';

  disabledTests =
    [
      # requires network access
      "test_gen_check_output"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # fails on darwin
      "test_expression_diff"
      # Fail on Hydra, see https://github.com/NixOS/nixpkgs/pull/130785
      "test_bpo_2142_workaround"
      "test_skip_magic_trailing_comma"
    ];
  # multiple tests exceed max open files on hydra builders
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  meta = with lib; {
    description = "The uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = licenses.mit;
    mainProgram = "black";
    maintainers = with maintainers; [
      sveitser
      autophagy
    ];
  };
}
