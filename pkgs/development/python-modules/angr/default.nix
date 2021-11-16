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
, nampa
, networkx
, progressbar2
, protobuf
, psutil
, pycparser
, pythonOlder
, pyvex
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
  });
in

buildPythonPackage rec {
  pname = "angr";
  version = "9.0.10534";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A2dqCABkqkn/rjWGc8hrGs60BK+V8j2+jVAYxnEpx8Y=";
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
    sqlalchemy
    pycparser
    pyvex
    sqlalchemy
    rpyc
    sortedcontainers
    unicorn'
  ];

  # Tests have additional requirements, e.g., pypcode and angr binaries
  # cle is executing the tests with the angr binaries
  doCheck = false;

  # See http://angr.io/api-doc/
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
