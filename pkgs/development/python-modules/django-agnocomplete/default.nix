{
  lib,
  django,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  requests,
  six,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
  mock,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "django-agnocomplete";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peopledoc";
    repo = "django-agnocomplete";
    rev = version;
    hash = "sha256-SDuLJM/ZvROkBOSbaVi6FMDRcR5Um4UrdPSq1ZMrlXM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
    requests
    six
  ];

  pythonImportsCheck = [
    "agnocomplete"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-django
    mock
    pyyaml
  ];

  postPatch = ''
    # 1. The "default.html" templates for forms and formsets will be removed.
    #    These were proxies to the equivalent "table.html" templates, but the new
    #    "div.html" templates will be the default from Django 5.0.
    #    https://docs.djangoproject.com/en/4.2/releases/4.1/
    #    https://docs.djangoproject.com/en/4.2/ref/forms/api/#as-div
    #
    # 2. assertQuerysetEqual() is deprecated in favor of assertQuerySetEqual()
    substituteInPlace demo/tests/test_fields.py \
      --replace-fail '"{}".format(form)' 'form.as_div()' \
      --replace-fail "assertQuerysetEqual" "assertQuerySetEqual"
  '';

  disabledTests = [
    # Exception message does not match for abstract class test, but the result
    # should be the same: can't instantiate abstract class
    "test_AgnocompleteBase"
    "test_AgnocompleteModel"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "front-end agnostic toolbox for autocompletion fields";
    homepage = "https://github.com/peopledoc/django-agnocomplete";
    changelog = "https://github.com/peopledoc/django-agnocomplete/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      LorenzBischof
      jcollie
    ];
  };
}
