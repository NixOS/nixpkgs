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
  version = "1.11.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04j1lxcsfyv03h0n0q7p2ig7a4n13x4x20fzxn8bkazpx6lyal22";
  };

  doCheck = false;  # too much

  buildInputs = [ mock tox pylint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
  };

}
