{ beautifulsoup4
, buildPythonPackage
, django
, fetchFromGitHub
, lib
, markdown
, poetry-core
, python
, pyyaml
}:

buildPythonPackage rec {
  pname = "django-pattern-library";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = pname;
    owner = "torchbox";
    rev = "v${version}";
    sha256 = "sha256-V299HpbfNLa9cpVhBfzD41oe95xqh+ktQVMMVvm5Xao=";
  };

  propagatedBuildInputs = [
    django
    pyyaml
    markdown
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api
  '';

  nativeBuildInputs = [ poetry-core ];

  checkInputs = [
    beautifulsoup4
  ];

  checkPhase = ''
    export DJANGO_SETTINGS_MODULE=tests.settings.dev
    ${python.interpreter} -m django test
  '';

  pythonImportsCheck = [ "pattern_library" ];

  meta = with lib; {
    description = "UI pattern libraries for Django templates";
    homepage = "https://github.com/torchbox/django-pattern-library/";
    changelog = "https://github.com/torchbox/django-pattern-library/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
    # https://github.com/torchbox/django-pattern-library/issues/212
    broken = lib.versionAtLeast django.version "4.2";
  };
}
