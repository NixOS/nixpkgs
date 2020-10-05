{ stdenv, buildPythonPackage, fetchPypi, django, isPy27 }:

buildPythonPackage rec {
  version = "3.12.1";
  pname = "djangorestframework";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d54452aedebb4b650254ca092f9f4f5df947cb1de6ab245d817b08b4f4156249";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
