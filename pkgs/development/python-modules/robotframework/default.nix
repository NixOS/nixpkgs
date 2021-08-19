{ lib, fetchFromGitHub, buildPythonPackage, jsonschema }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "09k008252x3l4agl9f8ai4a9mn0dp3m5s81mp1hnsf0hribb0s96";
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
