{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.8.2";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6714c3e4b0f8d524f193c91ecf5f5450092c2145439ac2769711f7eba89a9d9";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = http://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
