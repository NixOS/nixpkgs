{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pathable";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "pathable";
    tag = version;
    hash = "sha256-DjIn+hXZvx4tKyzQlWPwIxHD8vWy/jEvhdFY6HC+sdo=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pathable" ];

  meta = {
    description = "Library for object-oriented paths";
    homepage = "https://github.com/p1c2u/pathable";
    changelog = "https://github.com/p1c2u/pathable/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
