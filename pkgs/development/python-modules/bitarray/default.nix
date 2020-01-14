{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "bitarray";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f8706b651243c9faa981f075bcbdef2fab83e9b9bc9211ed2cb5849f9a68342";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = https://github.com/ilanschnell/bitarray;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
