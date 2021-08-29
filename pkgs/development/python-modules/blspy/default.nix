{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
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
  version = "1.0.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N1mk83uZrzSty2DyXfKiVp85z/jmztiUSRXKfNBRJV4=";
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
