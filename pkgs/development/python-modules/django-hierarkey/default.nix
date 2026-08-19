{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # propagates
  python-dateutil,

  # tests
  django-extensions,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-hierarkey";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-hierarkey";
    tag = version;
    hash = "sha256-ZsT696E1wBvElj99mMa6SuqVr7XD8NzJiMKGNOBOTrA=";
  };

  postPatch = ''
    substituteInPlace tests/settings.py \
      --replace-fail "/var/tmp" "$TMPDIR"
  '';

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  pythonImportsCheck = [ "hierarkey" ];

  nativeCheckInputs = [
    django-extensions
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Flexible and powerful hierarchical key-value store for your Django models";
    homepage = "https://github.com/raphaelm/django-hierarkey";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
