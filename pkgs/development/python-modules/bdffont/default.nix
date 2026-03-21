{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "bdffont";
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "bdffont";
    tag = finalAttrs.version;
    hash = "sha256-a93l7iX2/Htigs36zCv1x8SAGzycGU2y/stN0j794fw=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bdffont" ];

  meta = {
    homepage = "https://github.com/TakWolf/bdffont";
    description = "Library for manipulating Glyph Bitmap Distribution Format (BDF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
})
