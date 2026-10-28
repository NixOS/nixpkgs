{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  uv-build,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "cucumber-expressions";
  version = "20.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "cucumber-expressions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aPxD6snSQCA0y5tagvMy95bVtsk0qGf4KglTsuCGolU=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.0,<0.12.0" uv_build
  '';

  build-system = [ uv-build ];

  pythonImportsCheck = [ "cucumber_expressions" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = {
    changelog = "https://github.com/cucumber/cucumber-expressions/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Human friendly alternative to Regular Expressions";
    homepage = "https://github.com/cucumber/cucumber-expressions/tree/main/python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
