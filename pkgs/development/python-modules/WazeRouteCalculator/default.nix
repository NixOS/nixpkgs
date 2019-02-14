{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff6fe5524e18ea150e49cec69acd700275b52a31204a4eea1b11831637a3c0f3";
  };

  propagatedBuildInputs = [ requests ];

  # there are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Calculate actual route time and distance with Waze API";
    homepage = https://github.com/kovacsbalu/WazeRouteCalculator;
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
