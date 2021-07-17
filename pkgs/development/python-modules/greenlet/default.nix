{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
, python
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.1.0";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "c87df8ae3f01ffb4483c796fe1b15232ce2b219f0b18126948616224d3f658ee";
  };

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover -v greenlet.tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/python-greenlet/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = with licenses; [
      psfl  # src/greenlet/slp_platformselect.h & files in src/greenlet/platform/ directory
      mit
    ];
  };
}
