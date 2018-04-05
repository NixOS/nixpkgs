{ lib, buildPythonPackage, fetchPypi, pytz, pytest, freezegun }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ce4cb6fdd4393edd323227cba3a077bceb2a6ce5201c902c65e730046f41f14";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest freezegun ];

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };
}
