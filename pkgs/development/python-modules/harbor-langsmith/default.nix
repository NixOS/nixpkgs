{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # Avoid propagating two Harbor variants from plugin-enabled environments.
  propagateHarbor ? true,

  # build-system
  uv-build,

  # dependencies
  harbor,
  requests,

  # tests
  langsmith,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "harbor-langsmith";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "harbor-framework";
    repo = "harbor";
    tag = "v0.20.0";
    hash = "sha256-uV7aWuRw+KuyGkA9srhEioZ8YWH8PzwYx5SQ7BUdV6E=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/harbor-langsmith";

  # Nixpkgs has a newer uv-build than upstream allows.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.10.8,<0.11.0' 'uv_build>=0.10.8'
  '';

  build-system = [ uv-build ];

  buildInputs = lib.optionals (!propagateHarbor) [ harbor ];

  dependencies = [ requests ] ++ lib.optionals propagateHarbor [ harbor ];

  nativeCheckInputs = [
    langsmith
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "harbor_langsmith" ];

  meta = {
    description = "LangSmith plugin for Harbor jobs";
    homepage = "https://github.com/harbor-framework/harbor/tree/main/packages/harbor-langsmith";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.hobr ];
  };
})
