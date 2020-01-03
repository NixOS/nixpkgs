{ stdenv
, buildPythonPackage
, fetchPypi
, pyasn1
, pytest
}:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c35a52e00b672f832e5846826f1fb7507907f7d52fba6faa9e3c4cbe874fe4b";
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
