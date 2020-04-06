{ lib, buildPythonPackage, fetchFromGitHub
, pythonOlder
, requests
, pytest
, pre-commit
}:

buildPythonPackage rec {
  pname = "pylibgen";
  version = "2.0.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "joshuarli";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a9vhkgnkiwkicr2s287254mrkpnw9jq5r63q820dp3h74ba4kl1";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pre-commit ];

  # literally every tests does a network call
  doCheck = false;

  meta = with lib; {
    description = "Python interface to Library Genesis";
    homepage = https://pypi.org/project/pylibgen/;
    license = licenses.mit;
    maintainers = [ maintainers.nico202 ];
  };
}
