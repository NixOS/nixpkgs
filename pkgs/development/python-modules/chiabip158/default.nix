{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, cmake
, pybind11
, pythonOlder
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "chiabip158";
  version = "1.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HUgYVVQ7yc2X3ffnV7mCZf+oFUHl/29Mb4n91dRJ7gc=";
  };

  nativeBuildInputs = [ cmake setuptools-scm ];

  buildInputs = [ pybind11 ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Chia's implementation of BIP 158";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
