{ lib, buildPythonPackage, fetchFromGitHub, autograd, pytest, scipy }:

buildPythonPackage rec {
  pname = "autograd-gamma";
  version = "0.4.1";
  
  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = pname;
    rev = "v" + version;
    sha256 = "07fbc3nndr3qc3svja393ip4zcm3v7z94gv10w8ni5sjkj1fw24k";
  };
  
  propagatedBuildInputs = [ autograd scipy ];
  
  checkInputs = [ pytest ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Autograd compatible approximations to the gamma family of functions";
    homepage = "https://github.com/CamDavidsonPilon/autograd-gamma";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
