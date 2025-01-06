{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  django,
  djangorestframework,
  python,
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7c19seDzXDBOCCovYx3awuFu9SlgKVJOt5KvdDDKtMw=";
  };

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "taggit" ];

  nativeCheckInputs = [ djangorestframework ];

  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    # Replace directory of locale
    substituteInPlace ./tests/test_utils.py \
      --replace 'os.path.dirname(__file__), ".."' "\"$out/lib/python${lib.versions.majorMinor python.version}/site-packages/\""
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = {
    description = "Simple tagging for django";
    homepage = "https://github.com/jazzband/django-taggit";
    changelog = "https://github.com/jazzband/django-taggit/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ desiderius ];
  };
}
