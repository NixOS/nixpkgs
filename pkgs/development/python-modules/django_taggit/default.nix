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
  version = "1.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "044fzcpmns90kaxdi49qczlam4xsi8rl73rpfwvxx1gkcqzidgq1";
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
