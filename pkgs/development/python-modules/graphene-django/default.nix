{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  graphene,
  graphql-core,
  django,
  djangorestframework,
  promise,
  text-unidecode,

  django-filter,
  mock,
  py,
  pytest-django,
  pytest-random-order,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "graphene-django";
  version = "3.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphene-django";
    tag = "v${version}";
    hash = "sha256-uMkzgXn3YRgEU46Sv5lg60cvetHir9bv0mzJGDv79DI=";
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
    pytest7CheckHook
  ];

  disabledTests = [
    # https://github.com/graphql-python/graphene-django/issues/1510
    "test_should_filepath_convert_string"
    "test_should_choice_convert_enum"
    "test_should_multiplechoicefield_convert_to_list_of_enum"
    "test_perform_mutate_success_with_enum_choice_field"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
