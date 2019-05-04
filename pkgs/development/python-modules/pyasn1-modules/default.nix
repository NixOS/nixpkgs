{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, isPyPy
, pytest
}:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef721f68f7951fab9b0404d42590f479e30d9005daccb1699b0a51bb4177db96";
  };

  propagatedBuildInputs = [ pyasn1 ];

  checkInputs = [
    pytest
  ];

  # running tests through setup.py fails only for python2 for some reason:
  # AttributeError: 'module' object has no attribute 'suitetests'
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = https://pypi.python.org/pypi/pyasn1-modules;
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
