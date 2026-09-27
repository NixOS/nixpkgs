{
  lib,
  buildNpmPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:
let
  pname = "django-admin-sortable2";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "jrief";
    repo = "django-admin-sortable2";
    tag = version;
    hash = "sha256-noY0SELM+ZBWDoZ/pl1oUV/S0VICtG7sSaCtPGjjOpQ=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-zM2iSCrGX5sS7Ysmmo8nR+/V9pMOatN6DX/G+hGdFEU=";

    installPhase = ''
      runHook preInstall

      install -Dm644 adminsortable2/static/adminsortable2/js/*.js -t $out

      runHook postInstall
    '';
  };

  # This is required to get the unminified adminsortable2.js file used when
  # DEBUG=False
  assetsDebug = assets.overrideAttrs {
    npmBuildFlags = [
      "--"
      "--debug"
    ];
  };
in

buildPythonPackage rec {
  inherit pname version src;
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ django ];

  preBuild = ''
    install -Dm644 ${assets}/*.js -t adminsortable2/static/adminsortable2/js
    install -Dm644 ${assetsDebug}/*.js -t adminsortable2/static/adminsortable2/js
  '';

  pythonImportsCheck = [ "adminsortable2" ];

  # See https://github.com/jrief/django-admin-sortable2/blob/899402aa0aac301d27dc1c16116dc7c067bf4461/.github/workflows/publish.yml#L37-L50
  configurePhase =
    let
      djangoVersion = lib.versions.majorMinor django.version;
    in
    ''
      mkdir -p adminsortable2/static/adminsortable2/js
      mkdir -p adminsortable2/templates/adminsortable2/edit_inline
      cp ${django.src}/django/contrib/admin/static/admin/js/actions.js adminsortable2/static/adminsortable2/js/actions-${djangoVersion}.js
      cp ${django.src}/django/contrib/admin/templates/admin/edit_inline/stacked.html adminsortable2/templates/adminsortable2/edit_inline/stacked-django-${djangoVersion}.html
      cp ${django.src}/django/contrib/admin/templates/admin/edit_inline/tabular.html adminsortable2/templates/adminsortable2/edit_inline/tabular-django-${djangoVersion}.html
      patch -p0 adminsortable2/static/adminsortable2/js/actions-${djangoVersion}.js patches/actions-django-5.2.patch
      patch -p0 adminsortable2/templates/adminsortable2/edit_inline/stacked-django-${djangoVersion}.html patches/stacked-django-4.0.patch
      patch -p0 adminsortable2/templates/adminsortable2/edit_inline/tabular-django-${djangoVersion}.html patches/tabular-django-4.0.patch
    '';

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    changelog = "https://github.com/jrief/django-admin-sortable2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
