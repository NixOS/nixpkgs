{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7";
  };

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/decorator";
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
