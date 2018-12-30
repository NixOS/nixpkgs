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
  version = "1.17.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bbea0efc5af91e0a7d4c2b31650f61667bcc1d0d717784d78c03f0ed13bb374";
  };

  doCheck = false;  # too much

  buildInputs = [ mock tox pylint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
  };

}
