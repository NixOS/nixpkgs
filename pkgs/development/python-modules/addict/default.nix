{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "addict";
  version = "2.4.0";

  src = fetchFromGitHub {
     owner = "mewwts";
     repo = "addict";
     rev = "v2.4.0";
     sha256 = "1dcqwmi6xbcc7zmsmq3djhvbybsz806lh837sgbrxppcmw2sfma3";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "addict" ];

  meta = with lib; {
    description = "Module that exposes a dictionary subclass that allows items to be set like attributes";
    homepage = "https://github.com/mewwts/addict";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
