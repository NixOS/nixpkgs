{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, python
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.1.2";
  disabled = isPyPy;  # builtin for pypy

  src = fetchFromGitHub {
     owner = "python-greenlet";
     repo = "greenlet";
     rev = "1.1.2";
     sha256 = "15z4v2j3yh5x91hj7yr0hd79bmhgvvv0q8l1w79q3cd8n9zyy7l6";
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
