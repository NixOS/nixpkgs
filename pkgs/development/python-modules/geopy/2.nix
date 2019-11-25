{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, geographiclib
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "1.20.0";

  disabled = !isPy27; # only Python 2.7
  doCheck = false; # Needs network access

  propagatedBuildInputs = [ geographiclib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "9419bc90ee6231590c4ae7acf1cf126cefbd0736942da7a6a1436946e80830e2";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
