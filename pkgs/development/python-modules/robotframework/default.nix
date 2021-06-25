{ lib, fetchFromGitHub, buildPythonPackage, jsonschema }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1nkph0slrhss6y52y8jgbdc6m8hbqjilrwp3r00wwyqdifrfa1i6";
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
