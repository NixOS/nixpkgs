{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch

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
  version = "unstable-2022-03-03";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "f6ec0689c18929344c79ae363d2e3d5628fa4a2d";
    hash = "sha256-KTZ5jcoeHYXnlaF47t8jIi6+7NyMyA4hDPv+il3bt+U=";
  };

  patches = [
    ./graphene-3_2_0.patch
    (fetchpatch {
      url = "https://github.com/graphql-python/graphene-django/commit/ca555293a4334c26cf9a390dd1e3d0bd4c819a17.patch";
      excludes = [ "setup.py" ];
      sha256 = "sha256-RxG1MRhmpBKnHhSg4SV+DjZ3uA0nl9oUeei56xjtUpw=";
    })
  ];

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
