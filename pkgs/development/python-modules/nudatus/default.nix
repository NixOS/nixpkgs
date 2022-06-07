{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonPackages
}:

buildPythonPackage rec {
  pname = "nudatus";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "ZanderBrown";
    repo = pname;
    rev = version;
    sha256 = "yNFidirDkf624Zta8hcG/b/Q5RDzPtoCHEepSXdARXA=";
  };

  checkInputs = with pythonPackages; [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Strip comments from python scripts.";
    homepage = "https://github.com/ZanderBrown/nudatus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
