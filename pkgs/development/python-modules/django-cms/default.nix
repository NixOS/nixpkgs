{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools,
  django-classy-tags,
  django-formtools,
  django-treebeard,
  django-sekizai,
  djangocms-admin-style,
  python,
  dj-database-url,
  djangocms-text-ckeditor,
  fetchpatch,
  django-cms,
  gettext,
  iptools,
}:

buildPythonPackage rec {
  pname = "django-cms";
  version = "4.1.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-cms";
    rev = "refs/tags/${version}";
    hash = "sha256-2vA1teV6IkjtDo44uwEts1OGsBZ4dXRFGrasAHmgnRA=";
  };

  patches = [
    # Removed django-app-manage dependency by updating ./manage.py
    # https://github.com/django-cms/django-cms/pull/8061
    (fetchpatch {
      url = "https://github.com/django-cms/django-cms/commit/3270edb72f6a736b5cb448864ce2eaf68f061740.patch";
      hash = "sha256-DkgAfE/QGAXwKMNvgcYxtO0yAc7oAaAAui2My8ml1Vk=";
      name = "remove_django_app_manage_dependency.patch";
    })
    (fetchpatch {
      url = "https://github.com/django-cms/django-cms/pull/8061/commits/04005ff693e775db645c62fefbb62367822e66f9.patch";
      hash = "sha256-4M/VKEv7pnqCk6fDyA6FurSCCu/k9tNnz16wT4Tr0Rw=";
      name = "manage_py_update_dj_database_url.patch";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    django
    django-classy-tags
    django-formtools
    django-treebeard
    django-sekizai
    djangocms-admin-style
  ];

  nativeCheckInputs = [ gettext ];

  checkInputs = [
    dj-database-url
    djangocms-text-ckeditor
    iptools
  ];

  preCheck = ''
    # Disable ruff formatter test
    rm cms/tests/test_static_analysis.py
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test
    runHook postCheck
  '';

  # Tests depend on djangocms-text-ckeditor and djangocms-admin-style,
  # which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  passthru.tests = {
    runTests = django-cms.overridePythonAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "cms" ];

  meta = {
    description = "Lean enterprise content management powered by Django";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/django-cms/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
