{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfibaro";
  version = "0.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rappenze";
    repo = "pyfibaro";
    tag = finalAttrs.version;
    hash = "sha256-u0go/hJ+ZibbaUX5jRmBEfA6HaQaNIsuIm5l58nKuuQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pyfibaro" ];

  meta = {
    description = "Library to access FIBARO Home center";
    homepage = "https://github.com/rappenze/pyfibaro";
    changelog = "https://github.com/rappenze/pyfibaro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
