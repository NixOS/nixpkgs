{
  lib,
  stdenv,
  ailment,
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
  pythonOlder,
  pyvex,
  rich,
  rpyc,
  setuptools,
  sortedcontainers,
  sqlalchemy,
  sympy,
  unicorn-angr,
  unique-log-filter,
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.193";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${version}";
    hash = "sha256-7wBfxHWD5FRin8pfKup4izJBQzFN5N5dQZqIto5y83k=";
  };

  pythonRelaxDeps = [ "capstone" ];

  build-system = [ setuptools ];

  dependencies = [
    ailment
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
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
