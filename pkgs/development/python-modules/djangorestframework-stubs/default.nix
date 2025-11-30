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
  version = "3.16.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "djangorestframework-stubs";
    tag = version;
    hash = "sha256-A6IyRJwuc0eqRtkCHtWN5C5yCMdgxfygqmpHV+/MJhE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "<79.0.0" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # Upstream recommends mypy > 1.7 which we don't have yet, thus all tests are failing with 3.14.5 and below
  doCheck = false;

  pythonImportsCheck = [ "rest_framework-stubs" ];

  meta = with lib; {
    description = "PEP-484 stubs for Django REST Framework";
    homepage = "https://github.com/typeddjango/djangorestframework-stubs";
    changelog = "https://github.com/typeddjango/djangorestframework-stubs/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
