{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, geographiclib
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "1.21.0";

  disabled = !isPy27; # only Python 2.7
  doCheck = false; # Needs network access

  propagatedBuildInputs = [ geographiclib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p1sgy2p59j0297bp7c82b45bx4d3i1p4kvbgf89c9i0llyb80nw";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
