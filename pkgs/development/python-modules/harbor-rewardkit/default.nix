{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  uv-build,

  # dependencies
  litellm,

  # optional-dependencies
  markitdown,
  pillow,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "harbor-rewardkit";
  version = "0.1.7";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "harbor-framework";
    repo = "harbor";
    tag = "v0.20.0";
    hash = "sha256-uV7aWuRw+KuyGkA9srhEioZ8YWH8PzwYx5SQ7BUdV6E=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/rewardkit";

  # Nixpkgs has a newer uv-build than upstream allows.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.10.8,<0.11.0' 'uv_build>=0.10.8'
  '';

  build-system = [ uv-build ];

  dependencies = [ litellm ];

  optional-dependencies = {
    documents = [ markitdown ];
    image = [ pillow ];
    all = [
      markitdown
      pillow
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rewardkit" ];

  meta = {
    description = "Toolkit for defining and running task verifiers";
    homepage = "https://github.com/harbor-framework/harbor/tree/main/packages/rewardkit";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.hobr ];
    mainProgram = "rewardkit";
  };
})
