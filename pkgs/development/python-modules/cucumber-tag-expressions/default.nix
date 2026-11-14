{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pytest-html,
  pyyaml,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "cucumber-tag-expressions";
  version = "11.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DAdA/N7Xlji2Yuxn3Q7ujEVp1R40hYIpW+xW/xiKisE=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.0,<0.12.0" uv_build
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-html
    pyyaml
  ];

  meta = {
    changelog = "https://github.com/cucumber/tag-expressions/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxxk ];
  };
})
