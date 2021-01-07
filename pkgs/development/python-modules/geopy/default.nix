{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, geographiclib
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "2.1.0";

  disabled = !isPy3k; # only Python 3
  doCheck = false; # Needs network access

  propagatedBuildInputs = [ geographiclib ];

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0239a4achk49ngagb6aqy6cgzfwgbxir07vwi13ysbpx78y0l4g9";
  };

  meta = with lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    license = licenses.mit;
    maintainers = with maintainers; [GuillaumeDesforges];
  };
}
