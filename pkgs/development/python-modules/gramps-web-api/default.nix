{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  # TODO: remove
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,

  alembic,
  bleach,
  boto3,
  celery,
  click,
  ffmpeg-python,
  flask,
  flask-caching,
  flask-compress,
  flask-cors,
  flask-jwt-extended,
  flask-limiter,
  flask-sqlalchemy,
  gramps,
  gramps-ql,
  jsonschema,
  marshmallow,
  object-ql,
  orjson,
  pdf2image,
  pillow,
  pygobject3,
  pytesseract,
  sifts,
  sqlalchemy,
  unidecode,
  waitress,
  webargs,

  accelerate,
  openai,
  sentence-transformers,

  pytestCheckHook,
  pyyaml,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "gramps-web-api";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps-web-api";
    tag = "v${version}";
    hash = "sha256-T7Gl0kjC3P7xRd79Unb3GgKJp2Cw2WlvbMwieN5TJts=";
  };

  patches = [
    # fixes TestMediaArchiv::test_create_archive which tries to use an example
    # zip file from the nix store (which has non-zip compatible timestamps)
    ./remove-zip-timestamp-strictness.patch

    # unsure if this is really needed, but seems to work
    ./instance-path.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  # TODO: don't have to specify again
  nativeBuildInputs = [
    gobject-introspection
    gtk3
    wrapGAppsHook3
  ];

  pythonRelaxDeps = [ "boto3" ];

  dependencies = [
    alembic
    bleach
    boto3
    celery
    click
    ffmpeg-python
    flask
    flask-caching
    flask-compress
    flask-cors
    flask-jwt-extended
    flask-limiter
    flask-sqlalchemy
    gramps
    gramps-ql
    jsonschema
    marshmallow
    object-ql
    orjson
    pdf2image
    pillow
    pygobject3
    pytesseract
    sifts
    sqlalchemy
    unidecode
    waitress
    webargs

    # TODO: NEEDED HERE OR NOT?
    accelerate
    openai
    sentence-transformers

  ] ++ bleach.optional-dependencies.css;

  optional-dependencies = {
    ai = [
      accelerate
      openai
      sentence-transformers
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # don't try to download a semantic search model from the internet during testing
    substituteInPlace "tests/test_endpoints/__init__.py" \
      --replace-fail '"paraphrase-albert-small-v2"' '""'
  '';

  disabledTestPaths = [
    # mock_s3 is not found in moto 5.0.0+
    "tests/test_s3.py"
    "tests/test_endpoints/test_s3.py"

    # Requires a semantic search model be present
    "tests/test_endpoints/test_chat.py"
  ];

  disabledTests = [
    # network access needed
    "test_get_faces"
    "test_get_faces_requires_token"

    # the test wants to load some fonts
    "test_get_ocr"

    # pytest-celery is not packaged in nixpkgs
    "test_task_noauth"
    "test_task_nonexistant"
  ];

  pythonImportsCheck = [
    "gramps_webapi"
  ];

  meta = {
    description = "RESTful web API for Gramps - backend of Gramps Web";
    homepage = "https://github.com/gramps-project/gramps-web-api";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
