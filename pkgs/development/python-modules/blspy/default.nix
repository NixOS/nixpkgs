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
  version = "2.0.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mxLWhfPBBNP+D682GPa4JCctExuOo4QxkK1nBhhzZ3U=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pybind11.src;
      blst_src = fetchFromGitHub {
        owner = "supranational";
        repo = "blst";
        rev = "6b837a0921cf41e501faaee1976a4035ae29d893"; # pinned by blspy
        hash = "sha256-6iNpxaMRy438XoC0wk/c/tInNg1I0VuyGFV9sUFk5sc=";
      };
      sodium_src = fetchFromGitHub {
        owner = "AmineKhaldi";
        repo = "libsodium-cmake";
        rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"; # pinned by blspy
        hash = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
        fetchSubmodules = true;
      };
      catch2_src = fetchFromGitHub {
        owner = "catchorg";
        repo = "Catch2";
        rev = "v3.3.2"; # pinned by blspy
        hash = "sha256-t/4iCrzPeDZNNlgibVqx5rhe+d3lXwm1GmBMDDId0VQ=";
      };
    })
  ];

  # ImportError: cannot import name 'setuptools' from 'setuptools'
  # this is resolved in the next release, v2
  postPatch = ''
    substituteInPlace setup.py \
      --replace "from setuptools import Extension, setup, setuptools" "from setuptools import Extension, setup"
  '';

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
