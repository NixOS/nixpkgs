{
  lib,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pytestCheckHook,
  regex,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycep-parser";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruebel";
    repo = "pycep";
    tag = finalAttrs.version;
    hash = "sha256-pEFgpLfGcJhUWfs/nG1r7GfIS045cfNh7MVQokluXmM=";
  };

  build-system = [ uv-build ];

  # We can't use pythonRelaxDeps to relax the build-system
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build~=0.9.0" "uv_build"
  '';

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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
