{ lib
, stdenv
, ailment
, archinfo
, buildPythonPackage
, cachetools
, capstone
, cffi
, claripy
, cle
, cppheaderparser
, dpkt
, fetchFromGitHub
, gitpython
, itanium-demangler
, mulpyplexer
, nampa
, networkx
, progressbar2
, protobuf
, psutil
, pycparser
, pythonOlder
, pyvex
, rich
, rpyc
, sortedcontainers
, sqlalchemy
, sympy
, unicorn
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.72";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    rev = "refs/tags/v${version}";
    hash = "sha256-k36RT6E9Ye5F3dmTWS17D2/k3maXOlHhW6ygklolWjY=";
  };

  propagatedBuildInputs = [
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
    pyvex
    rich
    rpyc
    sortedcontainers
    sqlalchemy
    sympy
    unicorn
  ];

  setupPyBuildFlags = lib.optionals stdenv.isLinux [
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
  };
}
