{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "incremental";
  version = "17.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3";
  };

  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
