{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib

# build-system
, poetry-core

# dependencies
, django
, markdown
, pyyaml

# tests
, beautifulsoup4
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-pattern-library";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "torchbox";
    repo = "django-pattern-library";
    rev = "v${version}";
    hash = "sha256-Q8rv7RDlstTSlwmbmHV0vrnCV/lwz6VJf27BUllA34Y=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/torchbox/django-pattern-library/pull/232
      url = "https://github.com/torchbox/django-pattern-library/commit/e7a9a8928a885941391fb584eba81578a292ee7d.patch";
      hash = "sha256-3uUoxdVYEiF+to88qZRhOkh1++RfmsqCzO9JNMDqz6g=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    django
    pyyaml
    markdown
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings.dev";

  pythonImportsCheck = [ "pattern_library" ];

  meta = with lib; {
    description = "UI pattern libraries for Django templates";
    homepage = "https://github.com/torchbox/django-pattern-library/";
    changelog = "https://github.com/torchbox/django-pattern-library/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
