{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools-scm
, substituteAll
, cmake
, boost
, gmp
, pybind11
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "chiavdf";
  version = "1.0.11";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PjUgpMTdWLMFQdnrpeWmn8vA8SlORjmu52ODc/2hivE=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pybind11.src;
    })
  ];

  # x86 instructions are needed for this component
  BUILD_VDF_CLIENT = lib.optionalString (!stdenv.isx86_64) "N";

  nativeBuildInputs = [ cmake setuptools-scm ];

  buildInputs = [ boost gmp pybind11 ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Chia verifiable delay function utilities";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
