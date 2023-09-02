{ stdenv
, lib
, substituteAll
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, bladebit
, catch2
, cmake
, cxxopts
, ghc_filesystem
, pybind11
, pytestCheckHook
, pythonOlder
, psutil
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "chiapos";
  version = "2.0.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YY7GPgifMMeHxlW9sIA+youj+XTMu9zNDBeP5hR5sUY=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      inherit cxxopts ghc_filesystem;
      bladebit = bladebit.src;
      pybind11_src = pybind11.src;
      catch2_src = fetchFromGitHub {
        owner = "catchorg";
        repo = "Catch2";
        rev = "v3.3.2"; # pinned by src
        hash = "sha256-t/4iCrzPeDZNNlgibVqx5rhe+d3lXwm1GmBMDDId0VQ=";
      };
    })
  ];

  nativeBuildInputs = [ cmake setuptools-scm ];

  buildInputs = [ pybind11 ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  # A fix for cxxopts >=3.1
  postPatch = ''
    substituteInPlace src/cli.cpp \
      --replace "cxxopts::OptionException" "cxxopts::exceptions::exception"
  '';

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Chia proof of space library";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
