{ lib, buildPythonPackage, fetchPypi, idna, pytestCheckHook }:

buildPythonPackage rec {
  pname = "rfc3986";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835";
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
