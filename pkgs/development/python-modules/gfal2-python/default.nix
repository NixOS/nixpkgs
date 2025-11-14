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
  version = "1.13.1";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "cern-fts";
    repo = "gfal2-python";
    rev = "v${version}";
    hash = "sha256-OUpsnKSsFOhiSg0npJW/9Htl4XNt/6zEPuB9nd6b43w=";
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
    }
    // lib.optionalAttrs (gfal2-util != null) gfal2-util.tests or { };
  };
  meta = with lib; {
    description = "Python binding for gfal2";
    homepage = "https://github.com/cern-fts/gfal2-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
