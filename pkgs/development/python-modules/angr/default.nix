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

let
  unicorn' = unicorn.overridePythonAttrs (old: rec {
    pname = "unicorn";
    version = "2.0.1.post1";
    src = fetchFromGitHub {
      owner = "unicorn-engine";
      repo = pname;
      tag = version;
      sha256 = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
    };
    postPatch = ''
      # support python 3.12
      substituteInPlace unicorn/unicorn.py \
        --replace-quiet 'import distutils' '__import__("setuptools"); import distutils'
    '';
  });
in
buildPythonPackage rec {
  pname = "angr";
  version = "9.2.141";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${version}";
    hash = "sha256-rrJTYe3o/Ra8+EKAA7t0M02tWVN4Ul5ueUar7lpUvMg=";
  };

  build-system = [
    unicorn'
  ];

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
    unicorn'
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
    maintainers = with maintainers; [
      fab
      scoder12
    ];
  };
}
