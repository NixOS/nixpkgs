{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  logurich,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  pyvis,
  rich,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyvest";
  version = "6.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PakitoSec";
    repo = "cyvest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w2Cphhb1iNAFlJEglF1ndVRZErs6vc3+pb+BHYEp7Xw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.8,<0.12.0" "uv_build"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ uv-build ];

  dependencies = [
    click
    logurich
    pydantic
    rich
    typing-extensions
  ];

  optional-dependencies = {
    visualization = [
      pyvis
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cyvest" ];

  meta = {
    description = "Cybersecurity Investigation Model";
    homepage = "https://github.com/PakitoSec/cyvest";
    changelog = "https://github.com/PakitoSec/cyvest/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
