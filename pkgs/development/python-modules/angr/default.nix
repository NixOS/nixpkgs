{
  lib,
  angr-data,
  archinfo,
  buildPythonPackage,
  cachetools,
  capstone,
  cargo,
  cffi,
  cle,
  cxxheaderparser,
  fastmcp,
  fetchFromGitHub,
  gitpython,
  grpcio-tools,
  keystone-engine,
  lmdb,
  mcp,
  msgspec,
  mulpyplexer,
  networkx,
  opentelemetry-api,
  platformdirs,
  protobuf,
  psutil,
  pycparser,
  pydantic-ai-slim,
  pydemumble,
  pypcode,
  pyvex,
  python,
  pythonOlder,
  rich,
  runCommandCC,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  sortedcontainers,
  sqlalchemy,
  sympy,
  typing-extensions,
  unicorn,
  z3-solver,
}:

buildPythonPackage (finalAttrs: {
  pname = "angr";
  # Keep angr-management, angr, archinfo, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "10.0.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8aRhb6VIYoUVWC6YRco48f2vPazo0MZkHE/Tg4QARhs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-EVTtVUdkZGN8VF8fHGzWSkR7F2Q09ItPaLjzjyJRLFs=";
  };

  # pythonRelaxDeps cannot relax build-system requirements.
  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'grpcio-tools~=1.80.0' 'grpcio-tools' \
      --replace-fail 'protobuf>=6.31.1,<7' 'protobuf>=6.31.1' \
      --replace-fail '"z3-solver==5.1.0.0",' ""
  '';

  pythonRelaxDeps = [ "lmdb" ];

  build-system = [
    grpcio-tools
    protobuf
    pyvex
    setuptools
    setuptools-rust
    z3-solver
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  env.Z3_SYS_Z3_VERSION = z3-solver.version;

  dependencies = [
    angr-data
    archinfo
    cachetools
    capstone
    cffi
    cle
    cxxheaderparser
    gitpython
    lmdb
    msgspec
    mulpyplexer
    networkx
    platformdirs
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
    z3-solver
  ];

  optional-dependencies = {
    angrdb = [ sqlalchemy ];
    keystone = [ keystone-engine ];
    llm = [
      fastmcp
      mcp
      pydantic-ai-slim
    ];
    telemetry = [ opentelemetry-api ];
    unicorn = [ unicorn ];
  };

  # The full upstream suite requires large external fixtures and optional dependencies.
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "archinfo"
    "cle"
    "pypcode"
    "pyvex"
  ];

  passthru.tests.smoke =
    runCommandCC "angr-smoke-test"
      {
        __structuredAttrs = true;
        nativeBuildInputs = [
          (python.withPackages (_: [
            finalAttrs.finalPackage
            sqlalchemy
            unicorn
          ]))
        ];
      }
      ''
        cc -O1 ${./tests/fixture.c} -o fixture
        python ${./tests/smoke.py} "$PWD/fixture" ${finalAttrs.version}
        touch "$out"
      '';

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
