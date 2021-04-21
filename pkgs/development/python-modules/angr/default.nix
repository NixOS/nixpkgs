{ lib
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
, networkx
, progressbar2
, protobuf
, psutil
, pycparser
, pkgs
, pythonOlder
, pyvex
, sqlalchemy
, rpyc
, sortedcontainers
, unicorn
}:

buildPythonPackage rec {
  pname = "angr";
  version = "9.0.6281";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "10i4qdk8f342gzxiwy0pjdc35lc4q5ab7l5q420ca61cgdvxkk4r";
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
    networkx
    progressbar2
    protobuf
    psutil
    sqlalchemy
    pycparser
    pyvex
    sqlalchemy
    rpyc
    sortedcontainers
    unicorn
  ];

  # Tests have additional requirements, e.g., pypcode and angr binaries
  # cle is executing the tests with the angr binaries
  doCheck = false;
  pythonImportsCheck = [ "angr" ];

  meta = with lib; {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
    broken = true; # https://github.com/angr/angr/issues/2541
  };
}
