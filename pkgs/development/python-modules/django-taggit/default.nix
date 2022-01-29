{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, django
, djangorestframework
, python
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "2.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9f41e4ad58efe4b28d86f274728ee87eb98eeae90c9eb4b4efad39e5068184e";
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
