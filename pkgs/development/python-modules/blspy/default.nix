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
  version = "1.0.16";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XABdS6CCUJpZ9N1Vra078V0HoDU32u1l3yz96ZKHwFc=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pybind11.src;
      relic_src = fetchFromGitHub {
        owner = "Chia-Network";
        repo = "relic";
        rev = "215c69966cb78b255995f0ee9c86bbbb41c3c42b"; # pinned by blspy
        hash = "sha256-wivK18Cp7BMZJvrYxJgSHInRZgFgsgSzd0YIy5IWoYA=";
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
        rev = "v3.0.0-preview5"; # pinned by blspy
        hash = "sha256-IQ1yGZo3nKHTqScUoq3i3Njxqvk7uW8hQ3GT0/SxGaw=";
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
