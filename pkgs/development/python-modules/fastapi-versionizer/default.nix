{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  setuptools,

  # dependencies
  fastapi,
  natsort,

  # test dependencies
  httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-versionizer";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexschimpf";
    repo = "fastapi-versionizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kj7tjy8TDV9MYhqJdVUBRohkIsYoqbQX5qnnkNBJPig=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastapi
    natsort
  ];

  pythonImportsCheck = [
    "fastapi_versionizer"
    "fastapi_versionizer.versionizer"
  ];

  nativeCheckInputs = [
    httpx
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/alexschimpf/fastapi-versionizer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "API versionizer for FastAPI web applications";
    downloadPage = "https://github.com/alexschimpf/fastapi-versionizer/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/alexschimpf/fastapi-versionizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
