{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  uv-build,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cucumber-expressions";
  version = "19.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "cucumber-expressions";
    tag = "v${version}";
    hash = "sha256-0KuHvByHYx7/mjySfWIKp1+ZYw+XNO25eoo5DhPcUsY=";
  };

  sourceRoot = "${src.name}/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.0,<0.10.0" uv_build
  '';

  build-system = [ uv-build ];

  pythonImportsCheck = [ "cucumber_expressions" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = {
    changelog = "https://github.com/cucumber/cucumber-expressions/blob/${src.tag}/CHANGELOG.md";
    description = "Human friendly alternative to Regular Expressions";
    homepage = "https://github.com/cucumber/cucumber-expressions/tree/main/python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
