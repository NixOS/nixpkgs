{ buildPythonPackage, fetchPypi, django, lib, coverage }:

buildPythonPackage rec {
  pname = "rules";
  version = "2.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1bixkim9a15ddrbispznrbd96j7dbibvd3v502jsabxgw43w8iys";
  };

  propagatedBuildInputs = [ django ];

  checkInputs = [ coverage ];
  checkPhase = "coverage run tests/manage.py test testsuite";

  meta = with lib; {
    description = "Awesome Django authorization, without the database";
    license = licenses.mit;
    homepage = https://github.com/dfunckt/django-rules;
    maintainers = with maintainers; [ mredaelli ];
  };
}
