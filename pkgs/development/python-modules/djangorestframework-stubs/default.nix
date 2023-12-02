{ lib
, buildPythonPackage
, django-stubs
, fetchFromGitHub
, mypy
, py
, pytest-mypy-plugins
, pytestCheckHook
, pythonOlder
, requests
, types-pyyaml
, types-requests
, typing-extensions
}:

buildPythonPackage rec {
  pname = "djangorestframework-stubs";
  version = "3.14.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "djangorestframework-stubs";
    rev = "refs/tags/${version}";
    hash = "sha256-DNoD6V7l224yQa+AfI+KNviUJBxKB0u0m9B5qX5HuzQ=";
  };

  propagatedBuildInputs = [
    django-stubs
    mypy
    requests
    types-pyyaml
    types-requests
    typing-extensions
  ];

  nativeCheckInputs = [
    mypy
    py
    pytest-mypy-plugins
    pytestCheckHook
  ];

  meta = with lib; {
    description = "PEP-484 stubs for Django REST Framework";
    homepage = "https://github.com/typeddjango/djangorestframework-stubs";
    changelog = "https://github.com/typeddjango/djangorestframework-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}

