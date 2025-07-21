{
  lib,
  buildPythonPackage,
  django-stubs,
  fetchFromGitHub,
  mypy,
  py,
  coreapi,
  pytest-mypy-plugins,
  pytestCheckHook,
  pythonOlder,
  requests,
  types-pyyaml,
  setuptools,
  types-markdown,
  types-requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "djangorestframework-stubs";
  version = "3.16.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "djangorestframework-stubs";
    tag = version;
    hash = "sha256-q/9tCMT79TMHIQ4KH8tiunaTt7L6IItwNYBFlbNxBcE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django-stubs
    requests
    types-pyyaml
    types-requests
    typing-extensions
  ];

  optional-dependencies = {
    compatible-mypy = [ mypy ] ++ django-stubs.optional-dependencies.compatible-mypy;
    coreapi = [ coreapi ];
    markdown = [ types-markdown ];
  };

  nativeCheckInputs = [
    py
    pytest-mypy-plugins
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  # Upstream recommends mypy > 1.7 which we don't have yet, thus all testsare failing with 3.14.5 and below
  doCheck = false;

  pythonImportsCheck = [ "rest_framework-stubs" ];

  meta = with lib; {
    description = "PEP-484 stubs for Django REST Framework";
    homepage = "https://github.com/typeddjango/djangorestframework-stubs";
    changelog = "https://github.com/typeddjango/djangorestframework-stubs/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
