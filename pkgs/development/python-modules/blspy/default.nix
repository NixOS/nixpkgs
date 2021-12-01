{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, fetchpatch
, setuptools-scm
, substituteAll
, cmake
, boost
, gmp
, pybind11
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blspy";
  version = "1.0.6";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sULXnecEs8VI687pR9EK9jjYWlrB4tV4dt7Kzekaxb4=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pybind11.src;
      relic_src = fetchFromGitHub {
        owner = "relic-toolkit";
        repo = "relic";
        rev = "1885ae3b681c423c72b65ce1fe70910142cf941c"; # pinned by blspy
        hash = "sha256-tsSZTcssl8t7Nqdex4BesgQ+ACPgTdtHnJFvS9josN0=";
      };
      sodium_src = fetchFromGitHub {
        owner = "AmineKhaldi";
        repo = "libsodium-cmake";
        rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"; # pinned by blspy
        sha256 = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
        fetchSubmodules = true;
      };
    })

    # avoid dynamic linking error at import time
    (fetchpatch {
      url = "https://github.com/Chia-Network/bls-signatures/pull/287/commits/797241e9dae1c164c862cbdb38c865d4b124a601.patch";
      sha256 = "sha256-tlc4aA75gUxt5OaSNZqIlO//PXjmddVgVLYuVEFNmkE=";
    })
  ];

  nativeBuildInputs = [ cmake setuptools-scm ];

  buildInputs = [ boost gmp.static pybind11 ];

  pythonImportsCheck = [
    "blspy"
  ];

  # Note: upstream testsuite is just a single test.py script outside of any framework
  doCheck = false;

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    description = "BLS signatures with aggregation";
    homepage = "https://github.com/Chia-Network/bls-signatures/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
