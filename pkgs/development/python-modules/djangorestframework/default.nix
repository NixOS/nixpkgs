{ stdenv, buildPythonPackage, fetchPypi, django, isPy27 }:

buildPythonPackage rec {
  version = "3.11.1";
  pname = "djangorestframework";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6dd02d5a4bd2516fb93f80360673bf540c3b6641fec8766b1da2870a5aa00b32";
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
