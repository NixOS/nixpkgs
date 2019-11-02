{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "bitarray";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3eb500f8b9cde19e14472fcbee0195dbf0fbac006f8406a03f0cfb495dff20a0";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = https://github.com/ilanschnell/bitarray;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
