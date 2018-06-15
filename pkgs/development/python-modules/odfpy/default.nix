{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.3.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bcaf3b23aa9e49ed8c8c177266539b211add4e02402748a994451482a10cb1b";
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
