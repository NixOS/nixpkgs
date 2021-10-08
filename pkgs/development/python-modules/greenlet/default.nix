{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
, python
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.1.2";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "e30f5ea4ae2346e62cedde8794a56858a67b878dd79f7df76a0767e356b1744a";
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
