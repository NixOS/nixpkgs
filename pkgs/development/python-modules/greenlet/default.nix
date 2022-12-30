{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, unittestCheckHook
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "2.0.1";
  disabled = isPyPy; # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QuYCVkRg2g6O5ny21yNjY+5eExqhWUO2Zw5E5cLtD2c=";
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
