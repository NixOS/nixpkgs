{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# dependencies
, importlib-resources
, jinja2

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-swagger-ui";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = "py-swagger-ui";
    rev = version;
    hash = "sha256-XU+zrpefNW3+UA45P3wN5jNo8HWduG6T5krhqio92No=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-resources
    jinja2
  ];

  pythonImportsCheck = [
    "py_swagger_ui"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/spec-first/py-swagger-ui/releases/tag/${version}";
    description = "Swagger UI bundled for usage with Python";
    homepage = "https://github.com/spec-first/py-swagger-ui";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
