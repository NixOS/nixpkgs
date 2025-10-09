{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  uv-build,

  # dependencies
  django,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-bootstrap3";
  version = "25.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap3";
    tag = "v${version}";
    hash = "sha256-TaB2PeBjmCNFuEZ+To2Q3C6zlFCaaTB70LxQWWb5AEo=";
  };

  patches = [
    # https://github.com/zostera/django-bootstrap3/pull/1085
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/Prince213/django-bootstrap3/commit/d3285ad9c3de87aa763bb49b9666baed514f7c87.patch?full_index=1";
      hash = "sha256-VcRC7ehyVTl0KuovD8tNCbZnKXKCOGpux1XXUOoDaTw=";
    })
  ];

  build-system = [ uv-build ];

  dependencies = [ django ];

  pythonImportsCheck = [ "bootstrap3" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.app.settings";

  meta = with lib; {
    description = "Bootstrap 3 integration for Django";
    homepage = "https://github.com/zostera/django-bootstrap3";
    changelog = "https://github.com/zostera/django-bootstrap3/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
