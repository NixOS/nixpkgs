{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  loguru,
  pytestCheckHook,
  rich,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "logurich";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "logurich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYlmwDws8YjjcWGugD/CMqCoutKQj0W7J8NHkMzsX8U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.20,<0.10.0" "uv_build"
  '';

  pythonRelaxDeps = [ "rich" ];

  build-system = [ uv-build ];

  dependencies = [
    loguru
    rich
  ];

  optional-dependencies = {
    click = [
      click
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "logurich" ];

  meta = {
    description = "Logger that combine loguru and rich";
    homepage = "https://github.com/PakitoSec/logurich";
    changelog = "https://github.com/PakitoSec/logurich/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
