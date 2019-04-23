{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.9.2";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05sam4z69mypxk8fv415zvs8mp09jqsagmslrbs1qvk51lk6d8pp";
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
