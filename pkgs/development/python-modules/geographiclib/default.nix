{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "1.49";
  disabled = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "635da648fce80a57b81b28875d103dacf7deb12a3f5f7387ba7d39c51e096533";
  };

  doCheck = false;  # too much

  meta = with stdenv.lib; {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = licenses.mit;
    maintainers = with maintainers; [ mmesch ];
  };

}
