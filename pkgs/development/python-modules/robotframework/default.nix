{ lib, fetchFromGitHub, buildPythonPackage, jsonschema }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0j71awmfkwk7prz82kr1zbcl3nrih3396sshrygnqlrdjmgivd3p";
  };

  checkInputs = [ jsonschema ];

  checkPhase = ''
    python3 utest/run.py
  '';

  meta = with lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
