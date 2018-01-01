{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.3.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bcaf3b23aa9e49ed8c8c177266539b211add4e02402748a994451482a10cb1b";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
    license = lib.licenses.asl20;
  };
}
