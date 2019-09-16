{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pi54wqj2p6ka13x7q8d5zgqg9bcf7m5d00l7x5bi204qmhn65c6";
  };

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
