{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "bitarray";
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efb2dc83f0acb832a94af3687eea558d72512cf2e54a64fca56a10aacf57934c";
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
