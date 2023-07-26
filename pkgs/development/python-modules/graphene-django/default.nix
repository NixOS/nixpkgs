{ stdenv
, lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchFromGitHub

, graphene
, graphql-core
, django
, djangorestframework
, promise
, text-unidecode

, django-filter
, mock
, py
, pytest-django
, pytest-random-order
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "graphene-django";
  version = "3.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1vl1Yj9MVBej5aFND8A63JMIog8aIW9SdwiOLIUwXxI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    djangorestframework
    graphene
    graphql-core
    django
    promise
    text-unidecode
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=examples.django_test_settings
  '';

  nativeCheckInputs = [
    django-filter
    mock
    py
    pytest-django
    pytest-random-order
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # Python 3.11 support, https://github.com/graphql-python/graphene-django/pull/1365
    "test_django_objecttype_convert_choices_enum_naming_collisions"
    "test_django_objecttype_choices_custom_enum_name"
    "test_django_objecttype_convert_choices_enum_list"
    "test_schema_representation"
  ] ++ lib.optionals stdenv.isDarwin [
    # this test touches files in the "/" directory and fails in darwin sandbox
    "test_should_filepath_convert_string"
  ];

  meta = with lib; {
    description = "Integrate GraphQL into your Django project";
    homepage = "https://github.com/graphql-python/graphene-django";
    changelog = "https://github.com/graphql-python/graphene-django/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
