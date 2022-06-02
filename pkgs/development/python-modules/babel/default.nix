{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytestCheckHook, freezegun }:

buildPythonPackage rec {
  pname = "babel";
  version = "2.10.1";

  src = fetchPypi {
    pname = "Babel";
    inherit version;
    sha256 = "sha256-mK6soIYTPvs+HiqtA5aYdJDIQlkp3bz+BVAYT9xUzRM=";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytestCheckHook freezegun ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://babel.pocoo.org/";
    description = "Collection of internationalizing tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
