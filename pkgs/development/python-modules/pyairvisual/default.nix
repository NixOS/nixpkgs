{ lib, buildPythonPackage, isPy3k, fetchFromGitHub, requests
, requests-mock, pytest
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ng6k07n91k5l68zk3hl4fywb33admp84wqdm20qmmw9yc9c64fd";
  };

  checkInputs = [ pytest requests-mock ];
  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    py.test tests
  '';

  disabled = !isPy3k;

  meta = with lib; {
    description = "A thin Python wrapper for the AirVisual API";
    license = licenses.mit;
    homepage = "https://github.com/bachya/pyairvisual";
  };
}
