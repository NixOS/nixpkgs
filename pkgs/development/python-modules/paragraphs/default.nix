{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "paragraphs";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "paragraphs";
    tag = finalAttrs.version;
    hash = "sha256-iRrHTqM7goJ1Ep1dbVo9PwDe0mXpnrj80UV6UDnws14=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.25,<0.12.0" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "paragraphs" ];

  meta = {
    description = "Module to incorporate long strings";
    homepage = "https://github.com/ShayHill/paragraphs";
    changelog = "https://github.com/ShayHill/paragraphs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
