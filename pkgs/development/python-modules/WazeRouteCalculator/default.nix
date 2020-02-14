{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "889fe753a530b258bd23def65616666d32c48d93ad8ed211dadf2ed9afcec65b";
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
