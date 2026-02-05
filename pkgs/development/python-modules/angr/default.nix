{
  lib,
  stdenv,
  archinfo,
  buildPythonPackage,
  cachetools,
  capstone,
  cffi,
  claripy,
  cle,
  cppheaderparser,
  cxxheaderparser,
  dpkt,
  fetchFromGitHub,
  gitpython,
  itanium-demangler,
  mulpyplexer,
  nampa,
  networkx,
  progressbar2,
  protobuf,
  psutil,
  pycparser,
  pyformlang,
  pydemumble,
  pyvex,
  rich,
  rpyc,
  setuptools-rust,
  sortedcontainers,
  sqlalchemy,
  sympy,
  unicorn,
  unique-log-filter,
  cargo,
  rustPlatform,
  rustc,
  lmdb,
  msgspec,
  pypcode,
  pytestCheckHook,
  pytest-insta,
  keystone-engine,
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.197";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${version}";
    hash = "sha256-EMTYn6pvZaVb4mimRYfOt21wOUBTQD7YLhAzU9PpP5w=";
  };

  pythonRelaxDeps = [ "capstone" ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      ;
    hash = "sha256-/IQCbZUVGV5WNzIIELr5tfFPOITUqHj+zp8FH2bAuCU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    setuptools-rust
  ];

  dependencies = [
    archinfo
    cachetools
    capstone
    cffi
    claripy
    cle
    cppheaderparser
    cxxheaderparser
    dpkt
    gitpython
    itanium-demangler
    mulpyplexer
    nampa
    networkx
    progressbar2
    protobuf
    psutil
    pycparser
    pyformlang
    pydemumble
    pyvex
    rich
    rpyc
    sortedcontainers
    sympy
    unique-log-filter
    lmdb
    msgspec
    pypcode
  ];

  optional-dependencies = {
    angrdb = [ sqlalchemy ];
    unicorn = [ unicorn ];
    keystone = [ keystone-engine ];
  };

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  # cle is executing the tests with the angr binaries
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "claripy"
    "cle"
    "pyvex"
    "archinfo"
    "pypcode"
  ];

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
