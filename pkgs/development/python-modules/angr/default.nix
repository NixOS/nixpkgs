{
  lib,
  stdenv,
  angr,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-rust,
  pyvex,
  rustPlatform,
  cargo,
  rustc,
  archinfo,
  cachetools,
  capstone,
  cffi,
  claripy,
  cle,
  cxxheaderparser,
  gitpython,
  lmdb,
  msgspec,
  mulpyplexer,
  networkx,
  protobuf,
  psutil,
  pycparser,
  pydemumble,
  pypcode,
  rich,
  sortedcontainers,
  sympy,
  typing-extensions,
  sqlalchemy,
  keystone-engine,
  opentelemetry-api,
  pydantic,
  unicorn,
  pytestCheckHook,
  pytest-xdist,
  autoPatchelfHook,
  sphinxHook,
  furo,
  myst-parser,
  sphinx-autodoc-typehints,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.204";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v${version}";
    hash = "sha256-c6weHSSGhGmjjhkotELxCXhV+ACe5ub7T28hoVWM3aE=";
  };
in
buildPythonPackage rec {
  pname = "angr";
  inherit version;
  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${version}";
    hash = "sha256-eEFxubSQnVg+26Ie+F3iys9VlUPnUMyOPVFq3gS6MHo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-eO/Ap1cBncA5OhkWIeAol7TCyJ8LhQBkHXnr9RpcFCo=";
  };

  pythonRelaxDeps = [ "capstone" ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [
    archinfo
    cachetools
    capstone
    cffi
    claripy
    cle
    cxxheaderparser
    gitpython
    lmdb
    msgspec
    mulpyplexer
    networkx
    protobuf
    psutil
    pycparser
    pydemumble
    pypcode
    pyvex
    rich
    sortedcontainers
    sympy
    typing-extensions
  ];

  optional-dependencies = {
    angrdb = [ sqlalchemy ];
    keystone = [ keystone-engine ];
    telemetry = [ opentelemetry-api ];
    unicorn = [ unicorn ];
    all = [
      sqlalchemy
      keystone-engine
      opentelemetry-api
      unicorn
    ];
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    # building docs
    sphinxHook
    furo
    myst-parser
    sphinx-autodoc-typehints
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    autoPatchelfHook
  ]
  ++ optional-dependencies.all;

  dontAutoPatchelf = true;

  # llm integration requires pydantic-ai, which is not packaged in nixpkgs
  disabledTestPaths = [
    "tests/llm"
  ];

  disabledTests = [
    "test_manyfloatsum_symbolic_i386"
    "test_manyfloatsum_symbolic_x86_64"
  ];

  pythonImportsCheck = [
    "angr"
    "claripy"
    "cle"
    "pyvex"
    "archinfo"
  ];

  preCheck = ''
    rm -rf angr
    cp -r ${binaries} $TMPDIR/binaries
  ''
  + lib.optionalString (with stdenv.hostPlatform; isLinux && isx86_64) ''
    chmod +w $TMPDIR/binaries/tests/x86_64/ctype*
    autoPatchelf $TMPDIR/binaries/tests/x86_64/ctype*
  '';

  doCheck = false;

  passthru.tests.pytest = angr.overridePythonAttrs (prev: {
    doCheck = true;
  });

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fab
      misaka18931
    ];
  };
}
