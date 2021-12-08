{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "bitarray";
  version = "2.3.4";

  src = fetchFromGitHub {
     owner = "ilanschnell";
     repo = "bitarray";
     rev = "2.3.4";
     sha256 = "0jd5r8ggz870y3165b3p0na684g1jmf17gkfhl8fxw34hbvsmiwb";
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
