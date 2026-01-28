{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "model-bakery";
  version = "1.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "model-bakers";
    repo = "model_bakery";
    tag = finalAttrs.version;
    hash = "sha256-7RMFbUFYUJI8gI5GVQ6kivjb6oeHGKzYbyTukMjK+8Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "model_bakery" ];

  meta = {
    description = "Object factory for Django";
    homepage = "https://github.com/model-bakers/model_bakery";
    changelog = "https://github.com/model-bakers/model_bakery/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
