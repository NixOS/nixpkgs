{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1823b33d2caa7fc54ab5507eff316e74abfdc30434db8f3be908ab52a330021";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
