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
  version = "3.0.0b7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uPc9HNcciQpCcHLYespK8ICny5jOQaliFMyd2Yt6/as=";
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
    licenses = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
