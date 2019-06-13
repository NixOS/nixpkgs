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
  version = "1.18.1";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07a21f699b3daaef726de7278f5d65f944609306ab8a389e9f56e09abf86eac8";
  };

  doCheck = false;  # too much

  buildInputs = [ mock tox pylint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
  };

}
