{
  lib,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-taggit";
    tag = version;
    hash = "sha256-QLJhO517VONuf+8rrpZ6SXMP/WWymOIKfd4eyviwCsU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ django ];

  nativeCheckInputs = [ djangorestframework ];

  pythonImportsCheck = [ "taggit" ];

  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    # Replace directory of locale
    substituteInPlace tests/test_utils.py \
      --replace-fail 'os.path.dirname(__file__), ".."' "\"$out/lib/python${lib.versions.majorMinor python.version}/site-packages/\""
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = {
    description = "Simple tagging for django";
    homepage = "https://github.com/jazzband/django-taggit";
    changelog = "https://github.com/jazzband/django-taggit/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
  };
}
