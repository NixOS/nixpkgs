{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, geographiclib
, mock
, tox
, pylint
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "1.18.0";
  disabled = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e448b41932985d71329d6caba5d95be53207c49b74e88acd651fb7b9c6896750";
  };

  doCheck = false;  # too much

  buildInputs = [ geographiclib mock tox pylint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
  };

}
