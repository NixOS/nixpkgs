{ lib
, buildPythonPackage
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
, pytest-django
, pytest-random-order
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "graphene-django";
  version = "unstable-2021-06-11";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "e7f7d8da07ba1020f9916153f17e97b0ec037712";
    sha256 = "0b33q1im90ahp3gzy9wx5amfzy6q57ydjpy5rn988gh81hbyqaxv";
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

  checkInputs = [
    django-filter
    mock
    pytest-django
    pytest-random-order
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Integrate GraphQL into your Django project";
    homepage = "https://github.com/graphql-python/graphene-django";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
