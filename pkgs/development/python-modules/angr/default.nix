{
  lib,
  angr-data,
  archinfo,
  buildPythonPackage,
  cachetools,
  capstone,
  cargo,
  cffi,
  claripy,
  cle,
  cxxheaderparser,
  fetchFromGitHub,
  gitpython,
  grpcio-tools,
  keystone-engine,
  lmdb,
  msgspec,
  mulpyplexer,
  networkx,
  platformdirs,
  protobuf,
  psutil,
  pycparser,
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
}:

buildPythonPackage (finalAttrs: {
  pname = "angr";
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-00F2F8McL4JGWJzD9HjJoAFwMuGROMCN4ALh6qvaDgY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-+yDP+7EAP2w5VSA1m/wuUEvB7NfCecmDZ8iqXiX8dHw=";
  };

  # pythonRelaxDeps cannot relax build-system requirements.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'grpcio-tools~=1.80.0' 'grpcio-tools' \
      --replace-fail 'protobuf>=6.31.1,<7' 'protobuf>=6.31.1'
  '';

  pythonRelaxDeps = [ "lmdb" ];

  build-system = [
    grpcio-tools
    protobuf
    pyvex
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  dependencies = [
    angr-data
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
  ];

  optional-dependencies = {
    angrdb = [ sqlalchemy ];
    keystone = [ keystone-engine ];
    unicorn = [ unicorn ];
  };

  # The full upstream suite requires large external fixtures and optional dependencies.
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "archinfo"
    "claripy"
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
    maintainers = with lib.maintainers; [ fab ];
  };
})
