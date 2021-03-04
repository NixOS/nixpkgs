{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e31b472ac92e04ea943723cf781ec168e15049d91a3052203defb81652d2b086";
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
