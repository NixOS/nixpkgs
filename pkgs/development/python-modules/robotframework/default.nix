{ lib, fetchFromGitHub, buildPythonPackage, jsonschema }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AblBSkTCUrYlX4M35IHUIw7j2PGzALbGXpApiJgZlWE=";
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
