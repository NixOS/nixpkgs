{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.9.0";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dk1r2qiifws4bb2pq8xk5dbsrhli0fi14iqg59v360mpfq6ay30";
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
