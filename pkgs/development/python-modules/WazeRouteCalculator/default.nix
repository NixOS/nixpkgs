{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ex9yglaJkk0+Uo3Y+xpimb5boXz+4QdbJS2O75U6dUg=";
  };

  propagatedBuildInputs = [ requests ];

  # there are no tests
  doCheck = false;

  meta = with lib; {
    description = "Calculate actual route time and distance with Waze API";
    homepage = "https://github.com/kovacsbalu/WazeRouteCalculator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
