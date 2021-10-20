{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72ecfba4320a893c53f9706bebb2d55c270c1e51a28789361aa93e4a21319ed5";
  };

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/decorator";
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
