{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, unittestCheckHook
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.1.3.post0";
  disabled = isPyPy; # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9eCdxcbheWlp/Ut3XqFBfXDkml3ymqqOXRBnXZ4Rhyw=";
  };

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-v" "greenlet.tests" ];

  meta = with lib; {
    homepage = "https://github.com/python-greenlet/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = with licenses; [
      psfl # src/greenlet/slp_platformselect.h & files in src/greenlet/platform/ directory
      mit
    ];
  };
}
