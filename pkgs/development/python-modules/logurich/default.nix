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
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "logurich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Ez1tS/kDguq8mQImiu2/h64YsBCTVv4b4sT/tJaD7E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.20,<0.10.0" "uv_build"
  '';

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
    changelog = "https://github.com/PakitoSec/logurich/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
