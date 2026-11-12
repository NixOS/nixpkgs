{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "e2b-dockerfile-utils";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "E2B";
    tag = "@e2b/python-sdk@${finalAttrs.version}";
    hash = "sha256-+phem2IV9lc+V5j5wEpAcH4364wjX8bzOjjWGuvsA0Q=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/dockerfile-utils-python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13.4,<0.14.0" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "e2b_dockerfile_utils" ];

  meta = {
    description = "E2B Dockerfile utils";
    homepage = "https://github.com/e2b-dev/E2B/blob/main/packages/python-sdk";
    changelog = "https://github.com/e2b-dev/E2B/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mishushakov
    ];
  };
})
