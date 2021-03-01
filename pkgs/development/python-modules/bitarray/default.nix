{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae27ce4bef4f35b4cc2c0b0d9cf02ed49eee567c23d70cb5066ad215f9b62b3c";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
