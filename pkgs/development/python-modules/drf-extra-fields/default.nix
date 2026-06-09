{
  lib,
  buildPythonPackage,
  django,
  djangorestframework,
  fetchFromGitHub,
  filetype,
  pillow,
  psycopg2,
  pytest-django,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  pytz,
}:

buildPythonPackage rec {
  pname = "drf-extra-fields";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hipo";
    repo = "drf-extra-fields";
    tag = "v${version}";
    hash = "sha256-Ym4vnZ/t0ZdSxU53BC0ducJl1YiTygRSWql/35PNbOU";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
    filetype
  ];

  optional-dependencies = {
    Base64ImageField = [ pillow ];
  };

  nativeCheckInputs = [
    (django.override { withGdal = true; })
    psycopg2
    pytestCheckHook
    pytest-django
    pytz
  ]
  ++ optional-dependencies.Base64ImageField;

  pythonImportsCheck = [ "drf_extra_fields" ];

  disabledTests = [
    # pytz causes the following tests to fail
    "test_create"
    "test_create_with_base64_prefix"
    "test_create_with_webp_image"
    "test_remove_with_empty_string"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/Hipo/drf-extra-fields/issues/210
    "test_read_source_with_context"
  ];

  meta = {
    description = "Extra Fields for Django Rest Framework";
    homepage = "https://github.com/Hipo/drf-extra-fields";
    changelog = "https://github.com/Hipo/drf-extra-fields/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
