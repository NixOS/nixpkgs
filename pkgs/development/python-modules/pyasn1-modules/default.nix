{ lib
, buildPythonPackage
, fetchPypi
, pyasn1
, pytest
}:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e";
  };

  propagatedBuildInputs = [ pyasn1 ];

  nativeCheckInputs = [
    pytest
  ];

  # running tests through setup.py fails only for python2 for some reason:
  # AttributeError: 'module' object has no attribute 'suitetests'
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = "https://pypi.python.org/pypi/pyasn1-modules";
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
