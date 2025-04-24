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
  pythonOlder,
  pyvex,
  rich,
  rpyc,
  setuptools,
  sortedcontainers,
  sqlalchemy,
  sympy,
  unicorn,
  unique-log-filter,
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.133";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    rev = "refs/tags/v${version}";
    hash = "sha256-dHksVhuQUC0f55WNPSkVHTXTGVuul742LeWSz0CTwrw=";
  };

  postPatch = ''
    # unicorn is also part of build-system
    substituteInPlace pyproject.toml \
      --replace-fail "unicorn==2.0.1.post1" "unicorn"
  '';

  pythonRelaxDeps = [
    "capstone"
    "unicorn"
  ];

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
    pyvex
    rich
    rpyc
    sortedcontainers
    sqlalchemy
    sympy
    unicorn
    unique-log-filter
  ];

  optional-dependencies = {
    AngrDB = [ sqlalchemy ];
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

  meta = with lib; {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
    # angr is pining unicorn
    broken = versionAtLeast unicorn.version "2.0.1.post1";
  };
}
