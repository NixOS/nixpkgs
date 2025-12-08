{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
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
  version = "25.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M0ltXNEiKtczkTUrSujaFSU8Xeibk6gLPiyNmhnsJmY=";
  };

  patches = [
    (fetchpatch {
      name = "click-8.2-compat-1.patch";
      url = "https://github.com/psf/black/commit/14e1de805a5d66744a08742cad32d1660bf7617a.patch";
      hash = "sha256-fHRlMetE6+09MKkuFNQQr39nIKeNrqwQuBNqfIlP4hc=";
    })
    (fetchpatch {
      name = "click-8.2-compat-2.patch";
      url = "https://github.com/psf/black/commit/ed64d89faa7c738c4ba0006710f7e387174478af.patch";
      hash = "sha256-df/J6wiRqtnHk3mAY3ETiRR2G4hWY1rmZMfm2rjP2ZQ=";
    })
    (fetchpatch {
      name = "click-8.2-compat-3.patch";
      url = "https://github.com/psf/black/commit/b0f36f5b4233ef4cf613daca0adc3896d5424159.patch";
      hash = "sha256-SGLCxbgrWnAi79IjQOb2H8mD/JDbr2SGfnKyzQsJrOA=";
    })
  ];

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
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
    typing-extensions
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

  meta = with lib; {
    description = "Uncompromising Python code formatter";
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
