{ lib
, buildPythonPackage
, python
, fetchPypi
, pythonOlder
, django
, mock
, isort
, isPy3k
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "1.4.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9ed6e94bad0bed3bf062a6be7ee3db117fda02c6419c680d614197364ea018b";
  };

  propagatedBuildInputs = [ isort django ];

  checkInputs = [ mock ];
  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "django-taggit is a reusable Django application for simple tagging";
    homepage = "https://github.com/alex/django-taggit/tree/master/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
