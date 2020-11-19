{ stdenv
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
  version = "1.3.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a833bf71f4c2deddd9745924eee53be1c075d7f0020a06f12e29fa3d752732d";
  };

  propagatedBuildInputs = [ isort django ];

  checkInputs = [ mock ];
  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with stdenv.lib; {
    description = "django-taggit is a reusable Django application for simple tagging";
    homepage = "https://github.com/alex/django-taggit/tree/master/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
