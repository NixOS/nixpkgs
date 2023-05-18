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
  version = "1.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t0Fnsh9B83KiT5dFVVfHs7sm9HyNbMsp6goj3esoph8=";
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
