{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54c38050039232e1db4ad7375cfce6748d7b41c29e95a081c8a6d2c30364a2ce";
  };

  postPatch = ''
    substituteInPlace src/tests/test.py --replace "DocumentationTestCase" "NoDocumentation"
  '';

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
