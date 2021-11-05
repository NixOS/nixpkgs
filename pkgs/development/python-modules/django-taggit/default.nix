{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, django
, djangorestframework
, mock
, isort
, python
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "1.5.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5bb62891f458d55332e36a32e19c08d20142c43f74bc5656c803f8af25c084a";
  };

  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [
    "taggit"
  ];

  checkInputs = [
    djangorestframework
  ];

  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    # Replace directory of locale
    substituteInPlace ./tests/test_utils.py \
      --replace 'os.path.dirname(__file__), ".."' "\"$out/lib/python${lib.versions.majorMinor python.version}/site-packages/\""
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "Simple tagging for django";
    homepage = "https://github.com/jazzband/django-taggit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius ];
  };

}
