{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  pillow,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blurhash";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "halcy";
    repo = "blurhash-python";
    tag = "v${version}";
    hash = "sha256-lTPn2GTD7eQ9XkZyuttFqEvNgzcx6b7OdeMc5WOXrJs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pillow
    numpy
  ];

  pythonImportsCheck = [ "blurhash" ];

  meta = {
    changelog = "https://github.com/halcy/blurhash-python/releases/tag/${src.tag}";
    description = "Pure-Python implementation of the blurhash algorithm";
    homepage = "https://github.com/halcy/blurhash-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
