{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  fetchpatch2,
  jinja2,
  pillow,
  pytest-django,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "django-bootstrap5";
  version = "25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap5";
    tag = "v${version}";
    hash = "sha256-aqP2IkAkZsw5vbQxhiy9L3giSgb0seub9gsxPTajiXo=";
  };

  patches = [
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/zostera/django-bootstrap5/commit/d1d54f5fc8041d2781189321402b4f3937f77913.patch?full_index=1";
      hash = "sha256-cFOY+pu2TAZXpAipSIQh1nPPC0ipfncvpObcH667+ac=";
    })
  ];

  build-system = [ uv-build ];

  dependencies = [ django ];

  optional-dependencies = {
    jinja = [ jinja2 ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    (django.override { withGdal = true; })
    pillow
    pytest-django
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.app.settings
  '';

  disabledTests = [
    # urllib.error.URLError: <urlopen error [Errno -3] Temporary failure in name resolution>
    "test_get_bootstrap_setting"
  ];

  pythonImportsCheck = [ "django_bootstrap5" ];

  meta = with lib; {
    description = "Bootstrap 5 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap5";
    changelog = "https://github.com/zostera/django-bootstrap5/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ netali ];
  };
}
