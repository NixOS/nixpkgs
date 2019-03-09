{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09fe1bfb32291a658ba9baffe3fe176693f41362d74caba60fb04be01b447fa1";
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
