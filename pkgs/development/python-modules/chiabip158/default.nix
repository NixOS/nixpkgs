{ lib
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
  version = "1.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dG6A4n30uPswQWY/Wmi75HK4ZMCDNr9Lt05FRWEPYV8=";
  };

  nativeBuildInputs = [ cmake setuptools-scm ];

  buildInputs = [ pybind11 ];

  checkInputs = [
    pytestCheckHook
  ];

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    description = "Chia's implementation of BIP 158";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
