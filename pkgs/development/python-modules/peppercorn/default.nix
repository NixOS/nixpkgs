{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "peppercorn";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ltdoHXoEVFz7ryxvtm3meynPxCQhqiY+THjyy7hb5MY=";
  };

  meta = with lib; {
    description = "Library for converting a token stream into a data structure for use in web form posts";
    homepage = "https://docs.pylonsproject.org/projects/peppercorn/en/latest/";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.all;
  };
}
