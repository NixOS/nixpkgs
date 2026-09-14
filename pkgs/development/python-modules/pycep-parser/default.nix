{
  lib,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  regex,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycep-parser";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruebel";
    repo = "pycep";
    tag = finalAttrs.version;
    hash = "sha256-Z7OJWnVXINo4vdAVCm60l3TaoegKqaavG9pOsc+0NX4=";
  };

  build-system = [ uv-build ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv-build~=0.12.0" "uv-build"
  '';

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  pythonRelaxDeps = [ "regex" ];

  dependencies = [
    lark
    regex
    typing-extensions
  ];

  nativeCheckInputs = [
    assertpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycep" ];

  meta = {
    description = "Python based Bicep parser";
    homepage = "https://github.com/gruebel/pycep";
    changelog = "https://github.com/gruebel/pycep/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
