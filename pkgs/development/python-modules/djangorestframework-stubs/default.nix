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
  version = "3.14.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "djangorestframework-stubs";
    rev = "refs/tags/${version}";
    hash = "sha256-AOhNlhTZ6Upevb/7Z1sUQoIkIlwYlIcf1CC+Ag7H4bg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django-stubs
    requests
    types-pyyaml
    types-requests
    typing-extensions
  ];

  passthru.optional-dependencies = {
    compatible-mypy = [ mypy ] ++ django-stubs.optional-dependencies.compatible-mypy;
    coreapi = [ coreapi ];
    markdown = [ types-markdown ];
  };

  nativeCheckInputs = [
    py
    pytest-mypy-plugins
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Upstream recommends mypy > 1.7 which we don't have yet, thus all testsare failing with 3.14.5 and below
  doCheck = false;

  pythonImportsCheck = [ "rest_framework-stubs" ];

  meta = with lib; {
    description = "PEP-484 stubs for Django REST Framework";
    homepage = "https://github.com/typeddjango/djangorestframework-stubs";
    changelog = "https://github.com/typeddjango/djangorestframework-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
