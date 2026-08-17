{
  lib,
  fetchFromGitLab,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "trapper";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "trapper-project";
    repo = "trapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t9oun9hEofU2JO6oDTHL++/7CzeFYOKn8kXvL+9En6U=";
  };

  sourceRoot = "source/trapper";

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    aiofiles
    azure-storage-blob
    blake3
    boto3
    cairosvg
    camtrap-package
    celery
    connectorx
    dacite
    dataclasses-json
    django-allauth
    django-auth-ldap
    django-braces
    django-celery-beat
    django-celery-results
    django-crispy-forms
    django-debug-toolbar
    django-extensions
    django-extra-views
    django-filter
    django-formtools
    django-grappelli
    django-import-export
    django-mptt
    django-oauth-toolkit
    django-polymorphic
    django-recaptcha
    django-silk
    django-solo
    django-storages
    django-taggit
    django-timezone-field
    django-tinymce
    django
    djangorestframework-gis
    djangorestframework
    docutils
    drf-yasg
    fastapi
    ffmpeg-python
    frictionless
    gpxpy
    gunicorn
    ipython
    jsonschema
    lxml
    mock
    numpy
    pandas
    pillow
    polars
    psycopg2-binary
    pyarrow
    pykwalify
    pylibmc
    python-dateutil
    python-dotenv
    pytz
    pyyaml
    requests
    rest-pandas
    sentry-sdk
    sphinx
    timezonefinder
    umap-project
    uvicorn
    watchdog
  ];

  meta = {
    description = "AI driven open source web application for managing camera trapping projects";
license = lib.licenses.gpl3Only;
    homepage = "https://gitlab.com/trapper-project/trapper";
    changelog = "https://gitlab.com/trapper-project/trapper/-/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
