{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "bitarray";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8SA+kC1R3zGRfXfuupw/540DKHOirXjHN+JkIPAIDlg=";
  };

  checkPhase = ''
    cd $out
    ${python.interpreter} -c 'import bitarray; bitarray.test()'
  '';

  pythonImportsCheck = [ "bitarray" ];

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/blob/master/CHANGE_LOG";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
