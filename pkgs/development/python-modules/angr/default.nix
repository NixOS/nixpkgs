{
  lib,
  archinfo,
  angr-data,
  buildPythonPackage,
  cachetools,
  capstone,
  cargo,
  cffi,
  cle,
  cppheaderparser,
  cxxheaderparser,
  dpkt,
  fetchFromGitHub,
  fastmcp,
  gitpython,
  grpcio-tools,
  itanium-demangler,
  keystone-engine,
  lmdb,
  msgspec,
  mulpyplexer,
  mcp,
  nampa,
  networkx,
  opentelemetry-api,
  platformdirs,
  progressbar2,
  protobuf,
  psutil,
  pycparser,
  pydantic-ai-slim,
  pyformlang,
  pydemumble,
  pypcode,
  pyvex,
  rich,
  rpyc,
  rustc,
  rustPlatform,
  setuptools-rust,
  setuptools,
  sortedcontainers,
  sqlalchemy,
  sympy,
  unicorn-angr,
  unique-log-filter,
  z3-solver,
}:
buildPythonPackage (finalAttrs: {
  pname = "angr";
  version = "10.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBEKPDeqfEx/G+g3CxQNeVWbH8CkyPJEQnpSWaKQNTI=";
  };

  pythonRelaxDeps = true;

  build-system = [
    setuptools
    setuptools-rust
    z3-solver
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-kVDd3sXTyGZPPXg5rFZZqfC3UNqq6AxxHoZdhzMBKyo=";
  };

  dependencies = [
    angr-data
    archinfo
    cachetools
    capstone
    cffi
    cle
    cppheaderparser
    cxxheaderparser
    dpkt
    gitpython
    grpcio-tools
    itanium-demangler
    lmdb
    msgspec
    mulpyplexer
    nampa
    networkx
    platformdirs
    progressbar2
    protobuf
    psutil
    pycparser
    pyformlang
    pydemumble
    pypcode
    pyvex
    rich
    rpyc
    sortedcontainers
    sympy
    unique-log-filter
    z3-solver
  ];

  optional-dependencies = {
    angrdb = [ sqlalchemy ];
    keystone = [ keystone-engine ];
    telemetry = [ opentelemetry-api ];
    llm = [
      pydantic-ai-slim
      mcp
      fastmcp
    ];
    unicorn = [ unicorn-angr ];
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
    z3-solver
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"grpcio-tools~=1.80.0"' '"grpcio-tools"' \
      --replace-fail '"protobuf>=6.31.1,<7"' '"protobuf"' \
      --replace-fail '"pyvex==10.0.3"' '"pyvex"' \
      --replace-fail '"z3-solver==5.1.0.0",' ' '
  '';

  # Tests have additional requirements, e.g., pypcode and angr binaries
  # cle is executing the tests with the angr binaries
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "cle"
    "pyvex"
    "archinfo"
  ];

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fab
      letgamer
    ];
  };
})
