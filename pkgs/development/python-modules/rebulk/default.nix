{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  regex,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "rebulk";
  version = "6.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kdeSSDaQrrJJu1azNXWY3WWPD1MwZmgNuMPhtvfciSk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11,<0.12" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rebulk" ];

  meta = {
    description = "Advanced string matching from simple patterns";
    homepage = "https://github.com/Toilal/rebulk/";
    changelog = "https://github.com/Toilal/rebulk/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
