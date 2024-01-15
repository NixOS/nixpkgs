{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, online-judge-api-client
, requests
}:

buildPythonPackage rec {
  pname = "online-judge-tools";
  version = "11.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "oj";
    rev = "v${version}";
    sha256 = "0zkzmmjgjb6lyrzq1ip54cpnp7al9a7mcyjyi5vx58bvnx3q0c6m";
  };

  propagatedBuildInputs = [ colorama online-judge-api-client requests ];

  # Requires internet access
  doCheck = false;

  meta = with lib; {
    description = "Tools for various online judges. Download sample cases, generate additional test cases, test your code, and submit it.";
    homepage = "https://github.com/online-judge-tools/oj";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
