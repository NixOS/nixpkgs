{ lib, buildPythonPackage, fetchFromGitHub, unittestCheckHook }:

buildPythonPackage rec {
  pname = "apted";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JoaoFelipe";
    repo = "apted";
    rev = "828b3e3f4c053f7d35f0b55b0d5597e8041719ac";
    hash = "sha256-h8vJDC5TPpyhDxm1sHiXPegPB2eorEgyrNqzQOzSge8=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "APTED algorithm for the Tree Edit Distance";
    homepage = "https://github.com/JoaoFelipe/apted";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ McSinyx ];
  };
}
