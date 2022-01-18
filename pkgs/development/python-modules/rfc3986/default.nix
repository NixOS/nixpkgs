{ lib, buildPythonPackage, fetchPypi, pythonOlder, idna, pytestCheckHook }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "2.0.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l6rPnb1L/YKbqtbmMJ+mVzqvG+P2+nNcirBeRs7LJhw=";
  };

  propagatedBuildInputs = [ idna ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Validating URI References per RFC 3986";
    homepage = "https://rfc3986.readthedocs.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
