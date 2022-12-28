{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, scipy
, fluids
}:
buildPythonPackage rec {
  pname = "chemicals";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "CalebBell";
    repo = "chemicals";
    rev = "9b841f18accf87e97cc2c4bb73aea3ad1e198f67";
    hash = "sha256-4JDmfIqE99XrCUtTAZ8Hnicc+6K42EmPpwx6tKYn6dQ=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
    fluids
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/CalebBell/chemicals";
    description = "An extensive compilation of pure component chemical data";
    license = licenses.mit;
    maintainers = with maintainers; [ larsr ];
  };
}
