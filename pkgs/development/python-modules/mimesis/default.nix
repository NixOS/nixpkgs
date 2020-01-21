{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "mimesis";
  version = "3.3.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "4b8fc414bd101109615fa8b6ad49f1811199e2745a4e9ef527193a4ab69637fc";
  };
    
  meta = with lib; {
    description = "Fake data generator";
    homepage = "https://github.com/lk-geimfari/mimesis";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
