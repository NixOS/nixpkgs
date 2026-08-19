{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "bdffont";
  version = "0.0.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "bdffont";
    tag = finalAttrs.version;
    hash = "sha256-Dwma4KvHFJd1DsdB2fAbfRipZJWkY0tjlSzgaCVD58o=";
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
