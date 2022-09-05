{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytestCheckHook, freezegun }:

buildPythonPackage rec {
  pname = "babel";
  version = "2.10.3";

  src = fetchPypi {
    pname = "Babel";
    inherit version;
    sha256 = "sha256-dhRVNxHul0kPcyEm3Ad/jQrghOvGqW4j2xSCr6vbLFE=";
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
