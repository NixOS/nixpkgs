{ lib, buildPythonPackage, fetchFromGitHub, mock, pytest }:

buildPythonPackage rec {
  pname = "redo";
  version = "2.0.3";
  
  src = fetchFromGitHub {
    owner = "bhearsum";
    repo = "redo";
    rev = version;
    sha256 = "0gkl60dm04mbl9bdvsjz95l8zb6di6zw3i41s1rr7sk8k565rbc2";
  };
  
  checkInputs = [ mock pytest ];
  
  meta = with lib; {
    description = "Utilities to retry Python callables";
    homepage = "https://github.com/bhearsum/redo";
    license = licenses.mpl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
