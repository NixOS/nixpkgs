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
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPLk6uOHk5CJs9ddHYZJ4AiICXDAaM6dDoL4f9XilQg=";
  };

  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [
    "taggit"
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/jazzband/django-taggit/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius ];
  };
}
