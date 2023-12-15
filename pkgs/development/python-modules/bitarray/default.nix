{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitarray";
  version = "2.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4VWHsr3xjTLrO6JfX1pRvt0NwGsxEqTFPated1O8ZYg=";
  };

  checkPhase = ''
    cd $out
    ${python.interpreter} -c 'import bitarray; bitarray.test()'
  '';

  pythonImportsCheck = [
    "bitarray"
  ];

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/raw/${version}/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = with maintainers; [ bhipple ];
  };
}
