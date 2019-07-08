{ stdenv
, buildPythonPackage
, python
, fetchPypi
, pythonOlder
, django
, mock
, isort
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "0.23.0";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a21cbe7e0879f1364eef1c88a2eda89d593bf000ebf51c3f00423c6927075dce";
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
