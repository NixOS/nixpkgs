{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytz, requests, pytest, freezegun }:

buildPythonPackage rec {
  pname = "astral";
  version = "2.2";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "sffjunkie";
     repo = "astral";
     rev = "2.2";
     sha256 = "1vxls9z4w7c7hsj62z8yq0p8km0zf8rrjx3nk9b9lj60rn9m6s0s";
  };

  propagatedBuildInputs = [ pytz requests freezegun ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -m "not webtest"
  '';

  meta = with lib; {
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
