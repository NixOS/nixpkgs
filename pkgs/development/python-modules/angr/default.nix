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
, GitPython
, itanium_demangler
, mulpyplexer
, nampa
, networkx
, progressbar2
, protobuf
, psutil
, pycparser
, pythonOlder
, pyvex
, sympy
, sqlalchemy
, rpyc
, sortedcontainers
, unicorn
}:

let
  # Only the pinned release in setup.py works properly
  unicorn' = unicorn.overridePythonAttrs (old: rec {
    pname = "unicorn";
    version = "1.0.2-rc4";
    src =  fetchFromGitHub {
      owner = "unicorn-engine";
      repo = pname;
      rev = version;
      sha256 = "17nyccgk7hpc4hab24yn57f1xnmr7kq4px98zbp2bkwcrxny8gwy";
    };
    doCheck = false;
  });
in

buildPythonPackage rec {
  pname = "angr";
  version = "9.2.15";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9KWk4uB7VlYsnQbDCRgnVkis0UAZfiI2xH9cAD1Dd7M=";
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
    GitPython
    itanium_demangler
    mulpyplexer
    nampa
    networkx
    progressbar2
    protobuf
    psutil
    pycparser
    pyvex
    rpyc
    sortedcontainers
    sqlalchemy
    sympy
    unicorn'
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
