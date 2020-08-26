{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45bba08bc142781ec7e18a847735219390808f9b6279c356252edddaee1f5fcd";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
