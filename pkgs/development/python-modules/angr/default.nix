{
  lib,
  angr-data,
  archinfo,
  buildPythonPackage,
  cachetools,
  callPackage,
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
  version = "10.0.5";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-memxffALYmcDNm1MgzgBom+5FNFKI4ympOJvY/NsHAg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-rlztS1GC5GCBHdr9VaeGNOp5ni0qcA8ot1RSJlXFuMI=";
  };

  pythonRelaxDeps = [
    "cxxheaderparser"
    "lmdb"
    "pycparser"
    "pypcode"
    "z3-solver"
  ];

  postPatch = ''
    # Nix supplies the build dependency; keep the runtime requirement.
    sed -i '/^\[build-system\]/,/^\[/{ /"z3-solver/d; }' pyproject.toml

    # cxxheaderparser 1.x represents member-function pointers using Pointer.
    substituteInPlace angr/sim_type.py \
      --replace-fail 'cxxheaderparser.types.MemberPointer' \
        'getattr(cxxheaderparser.types, "MemberPointer", cxxheaderparser.types.Pointer)'
  '';

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

  passthru.updateScript = {
    command = [ (lib.getExe (callPackage ./update.nix { })) ];
    supportedFeatures = [ "commit" ];
  };

  passthru.tests.smoke =
    runCommandCC "angr-smoke-test"
      {
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
