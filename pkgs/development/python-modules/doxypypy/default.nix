{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "doxypypy";
  version = "0.8.8.6";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "627571455c537eb91d6998d95b32efc3c53562b2dbadafcb17e49593e0dae01b";
  };
    
  meta = with lib; {
    description = "Doxygen filter for Python";
    homepage = "https://github.com/Feneric/doxypypy";
    license = licenses.gpl2;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
