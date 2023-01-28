{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330";
  };

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/decorator";
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
