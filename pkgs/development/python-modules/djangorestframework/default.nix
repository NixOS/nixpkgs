{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.9.3";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w1rc8cpw89sll5wsg1aj1w3klk91a1bsdz9y4zhg5xrc0qpd118";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = https://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
