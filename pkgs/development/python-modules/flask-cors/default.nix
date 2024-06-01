{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flask,
  packaging,
  pytestCheckHook,
  setuptools,

  # for passthru.tests
  aiobotocore,
  moto,
}:

buildPythonPackage rec {
  pname = "flask-cors";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    rev = "refs/tags/${version}";
    hash = "sha256-DbTeq18CLuwj8lzQnpyPMEfxgR97XlF0s37wkTYd4O4=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
    packaging
  ];

  passthru.tests = {
    inherit aiobotocore moto;
  };

  meta = with lib; {
    description = "Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    changelog = "https://github.com/corydolphin/flask-cors/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickcao ];
  };
}
