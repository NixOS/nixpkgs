{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, geographiclib
}:

buildPythonPackage rec {
  pname = "geopy-unstable";
  version = "2019-11-10";

  disabled = !isPy3k; # only Python 3
  doCheck = false; # Needs network access

  propagatedBuildInputs = [ geographiclib ];

  src = fetchFromGitHub {
    owner = "geopy";
    repo = "geopy";
    rev = "531b7de6126838a3e69370227aa7f2086ba52b89";
    sha256 = "07l1pblzg3hb3dbvd9rq8x78ly5dv0zxbc5hwskqil0bhv5v1p39";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
