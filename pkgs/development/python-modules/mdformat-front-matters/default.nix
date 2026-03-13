{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  mdformat,
  mdit-py-plugins,
  ruamel-yaml,
  toml,

  # tests
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-front-matters";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyleking";
    repo = "mdformat-front-matters";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nfthUgOmKI57d+xLMmzveYPugzvvwkIzA//+CgvJGRw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.10" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
    toml
  ];

  pythonImportsCheck = [ "mdformat_front_matters" ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  meta = {
    description = "mdformat plugin to format YAML, TOML, or JSON front matter";
    homepage = "https://github.com/kyleking/mdformat-front-matters";
    changelog = "https://github.com/KyleKing/mdformat-front-matters/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
