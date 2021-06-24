{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e02f79fba7a470d438eb39017d503498faaf760b17b6b46af1a9de12fd58d311";
  };

  pythonImportsCheck = [ "bitarray" ];

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
