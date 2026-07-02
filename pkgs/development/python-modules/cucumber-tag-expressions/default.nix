{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pytest-html,
  pyyaml,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cucumber-tag-expressions";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cucumber";
    repo = "tag-expressions";
    tag = "v${version}";
    hash = "sha256-jkuez7C3YDGmv484Lmc5PszVbnVXkcC12RryvTJkxxg=";
  };

  sourceRoot = "${src.name}/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.0,<0.11.0" uv_build
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
    changelog = "https://github.com/cucumber/tag-expressions/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/cucumber/tag-expressions";
    description = "Provides tag-expression parser for cucumber/behave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxxk ];
  };
}
