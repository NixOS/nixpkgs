{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pydantic,
  hatchling,
  djangorestframework,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "drf-pydantic";
  version = "2.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgebv";
    repo = "drf-pydantic";
    tag = "v${version}";
    hash = "sha256-2HAMV6yiV3NXbnYKGe8IseKPUv411n6LZBDVI96KC8Q=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    pydantic
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ pydantic.optional-dependencies.email;

  meta = {
    changelog = "https://github.com/georgebv/drf-pydantic/releases/tag/${src.tag}";
    description = "Use pydantic with the Django REST framework";
    homepage = "https://github.com/georgebv/drf-pydantic";
    maintainers = [ lib.maintainers.kiara ];
    license = lib.licenses.mit;
  };
}
