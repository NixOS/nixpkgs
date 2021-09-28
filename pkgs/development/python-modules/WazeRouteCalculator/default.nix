{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "131f72825689924d3e528dd8fb1a6299be5ba17cfee1075b252d8eef953a7548";
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
