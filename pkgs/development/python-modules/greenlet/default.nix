{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
, python
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.1.1";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0f22774cd8294078bdf7392ac73cf00bfa1e5e0ed644bd064fdabc5f2a2f481";
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
