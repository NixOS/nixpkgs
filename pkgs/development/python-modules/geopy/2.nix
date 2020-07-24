{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, geographiclib
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "1.22.0";

  disabled = !isPy27; # only Python 2.7
  doCheck = false; # Needs network access

  propagatedBuildInputs = [ geographiclib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jypkaqlbyr8icqypwm23lzsvq7flakp3a3nqr8ib5fmd0fzsq7q";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
