{ lib, buildPythonPackage, fetchFromGitHub, nbconvert, pytest, requests, responses }:

buildPythonPackage rec {
  pname = "nbconflux";
  version = "0.7.0";
  
  src = fetchFromGitHub {
    owner = "Valassis-Digital-Media";
    repo = "nbconflux";
    rev = version;
    sha256 = "1708qkb275d6f7b4b5zmqx3i0jh56nrx2n9rwwp5nbaah5p2wwlh";
  };
    
  propagatedBuildInputs = [ nbconvert requests ];
  
  checkInputs = [ pytest responses ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Converts Jupyter Notebooks to Atlassian Confluence (R) pages using nbconvert";
    homepage = "https://github.com/Valassis-Digital-Media/nbconflux";
    license = licenses.bsd3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
