{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytest, omegaconf, pathlib2 }:

buildPythonPackage rec {
  pname = "hydra";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = version;
    sha256 = "0plbls65qfrvvigza3qvy0pwjzgkz8ylpgb1im14k3b125ny41ad";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ omegaconf ] ++ lib.optional isPy27 pathlib2;

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  meta = with lib; {
    description = "A framework for configuring complex applications";
    homepage = https://hydra.cc;
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
