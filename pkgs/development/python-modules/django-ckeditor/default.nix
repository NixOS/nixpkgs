{
  lib,
  buildPythonPackage,
  django,
  django-extensions,
  django-js-asset,
  fetchFromGitHub,
  pillow,
  python,
  pythonOlder,
  selenium,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-ckeditor";
  version = "6.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django-ckeditor";
    repo = "django-ckeditor";
    tag = version;
    hash = "sha256-tPwWXQAKoHPpZDZ+fnEoOA29at6gUXBw6CcPdireTr8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
    django-js-asset
    pillow
  ];

  DJANGO_SETTINGS_MODULE = "ckeditor_demo.settings";

  checkInputs = [
    django-extensions
    selenium
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test
    runHook postCheck
  '';

  pythonImportsCheck = [ "ckeditor" ];

  meta = with lib; {
    description = "Django admin CKEditor integration";
    homepage = "https://github.com/django-ckeditor/django-ckeditor";
    changelog = "https://github.com/django-ckeditor/django-ckeditor/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
    knownVulnerabilities = [
      ''
        django-ckeditor bundles CKEditor 4.22.1 which isn’t supported anmyore and
        which does have unfixed security issues

        Existing users of django-ckeditor should consider switching to a
        different editor such as CKEditor 5 (django-ckeditor-5), after verifying
        that its GPL licensing terms are acceptable, or ProseMirror
        (django-prose-mirror by the author of django-ckeditor). Support of the
        CKEditor 4 package is provided by its upstream developers as a
        non-free/commercial LTS package until December 2028.

        Note that while there are publically known vulnerabilities for the
        CKEditor 4 series, the exploitability of these issues depends on how
        CKEditor is used by the given Django application.

        Further information:

        * List of vulnerabilites fixed in CKEditor 4.24.0-lts:

          * GHSA-fq6h-4g8v-qqvm
          * GHSA-fq6h-4g8v-qqvm
          * GHSA-mw2c-vx6j-mg76

        * The django-ckeditor deprecation notice:
          <https://406.ch/writing/django-ckeditor/>

        * The non-free/commerical CKEditor 4 LTS package:
          <https://ckeditor.com/ckeditor-4-support/>
      ''
    ];
  };
}
