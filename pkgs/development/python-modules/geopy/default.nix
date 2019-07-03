{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, tox
, pylint
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "1.20.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9419bc90ee6231590c4ae7acf1cf126cefbd0736942da7a6a1436946e80830e2";
  };

  doCheck = false;  # too much

  buildInputs = [ mock tox pylint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
  };

}
