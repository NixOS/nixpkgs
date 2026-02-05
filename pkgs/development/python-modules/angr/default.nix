{
  lib,
  stdenv,
  archinfo,
  angr,
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

  pythonImportsCheck = [
    "angr"
    "claripy"
    "cle"
    "pyvex"
    "archinfo"
    "pypcode"
  ];

  doCheck = false;
  passthru.tests.pytest = angr.overridePythonAttrs (prev: {
    doCheck = true;
    dependencies =
      prev.dependencies
      ++ prev.optional-dependencies.angrdb
      ++ prev.optional-dependencies.unicorn
      ++ prev.optional-dependencies.keystone;
  });

  nativeCheckInputs = [
    pytestCheckHook
    pytest-insta
  ];

  preCheck =
    let
      binaries = fetchFromGitHub {
        owner = "angr";
        repo = "binaries";
        tag = "v${version}";
        hash = "sha256-x5Ot4UlJelvYANQc8h0O6FlMEEKtdWDrrQ1ku1cwey4=";
      };
    in
    ''
      cd ..
      cp -r ${binaries} binaries
    '';

  enabledTestPaths = [ "source/tests" ];

  disabledTestPaths = [
    "source/tests/engines/test_unicorn.py"
  ];

  meta = {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    changelog = "https://github.com/theopolis/uefi-firmware-parser/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
