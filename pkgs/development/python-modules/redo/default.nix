{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "redo";
  version = "2.0.3";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "71161cb0e928d824092a5f16203939bbc0867ce4c4685db263cf22c3ae7634a8";
  };
    
  meta = with lib; {
    description = "Utilities to retry Python callables";
    homepage = "https://github.com/bhearsum/redo";
    license = licenses.mpl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
