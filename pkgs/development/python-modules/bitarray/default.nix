{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe4444d92b17073bf1f9f24e3015a0e5bb70a645c47df93ef8a9ce8be33fcbad";
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
