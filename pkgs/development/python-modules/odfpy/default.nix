{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "596021f0519623ca8717331951c95e3b8d7b21e86edc7efe8cb650a0d0f59a2b";
  };

  # Python 2.7 uses a different ordering for xml namespaces.
  # The testAttributeForeign test expects "ns44", but fails since it gets "ns43"
  checkPhase = " " + lib.optionalString (!isPy27) ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
    license = lib.licenses.asl20;
  };
}
