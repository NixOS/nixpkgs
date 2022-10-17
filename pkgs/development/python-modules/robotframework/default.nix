{ lib, fetchFromGitHub, buildPythonPackage, jsonschema }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-aJUXqY6OFlbdLIr5Qpg27mGFm6hD+WvCrqXmf204WUo=";
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
