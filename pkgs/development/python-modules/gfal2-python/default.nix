{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  gfal2,
  glib,
  pythonAtLeast,
  # For tests
  gfal2-util ? null,
}:
buildPythonPackage rec {
  pname = "gfal2-python";
  version = "1.12.2";
  src = fetchFromGitHub {
    owner = "cern-fts";
    repo = "gfal2-python";
    rev = "v${version}";
    hash = "sha256-Xk+gLTrqfWb0kGB6QhnM62zAHVFb8rRAqCIBxn0V824=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    boost
    gfal2
    glib
  ];
  # We don't want setup.py to (re-)execute cmake in buildPhase
  # Besides, this package is totally handled by CMake, which means no additional configuration is needed.
  dontConfigure = true;
  pythonImportsCheck = [ "gfal2" ];
  passthru = {
    inherit gfal2;
    tests = {
      inherit gfal2-util;
    } // lib.optionalAttrs (gfal2-util != null) gfal2-util.tests or { };
  };
  meta = with lib; {
    description = "Python binding for gfal2";
    homepage = "https://github.com/cern-fts/gfal2-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ShamrockLee ];
    # It currently fails to build against Python 3.12 or later,
    # complaining CMake faililng to find Python include path, library path and site package path.
    broken = pythonAtLeast "3.12";
  };
}
