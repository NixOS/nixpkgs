{ lib
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  pname = "isodate";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "SMWIHefosKDWSMsCTIBi3ITnuEDtgehkx2FP08Envek=";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s src/isodate/tests
  '';

  meta = with lib; {
    description = "ISO 8601 date/time parser";
    homepage = "http://cheeseshop.python.org/pypi/isodate";
    license = licenses.bsd0;
  };

}
