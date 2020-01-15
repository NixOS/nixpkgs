{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "WazeRouteCalculator";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kwr7r1cn9xxvf9asxqhsy4swx4v6hsgw5cr5wmn71qg11k1i5cx";
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
