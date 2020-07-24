{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pz3yd9rhz3cb0yf7dbjhd1awm0w7vsbj73k4v95484j2kdxk3d4";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
