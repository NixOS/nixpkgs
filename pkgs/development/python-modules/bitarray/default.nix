{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "bitarray";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7DpPbXEaee0jrqlUFjjTNT3D8IPyk6ExgLFLSC4+Ge8=";
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
