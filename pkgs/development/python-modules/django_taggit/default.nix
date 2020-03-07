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
  version = "1.2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4186a6ce1e1e9af5e2db8dd3479c5d31fa11a87d216a2ce5089ba3afde24a2c5";
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
    homepage = https://github.com/alex/django-taggit/tree/master/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
