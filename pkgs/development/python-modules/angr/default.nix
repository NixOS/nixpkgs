{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  setuptools-rust,

  # dependencies
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
  pyvex,
  rich,
  sortedcontainers,
  sympy,
  typing-extensions,

  # optional-dependencies
  sqlalchemy,
  unicorn-angr,
}:

buildPythonPackage (finalAttrs: {
  pname = "angr";
  version = "9.2.212";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wEIfmO3VGCEJnHENghG4o90r/kkZWjS/XiTyAl6zD9w=";
  };

  build-system = [
    pyvex
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WPMBFVb+D8eWkF25doTYcFM7s8XRgkoaHXL0rtLwoqk=";
  };

  pythonRelaxDeps = [
    "capstone"
    "lmdb"
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
    unicorn = [ unicorn-angr ];
  };

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  # Tests have additional requirements, e.g., pypcode and angr binaries
  # cle is executing the tests with the angr binaries
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "claripy"
    "cle"
    "pyvex"
    "archinfo"
  ];

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    downloadPage = "https://github.com/angr/angr";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
