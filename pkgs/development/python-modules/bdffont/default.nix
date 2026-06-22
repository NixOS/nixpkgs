{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "bdffont";
  version = "0.0.39";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "bdffont";
    tag = finalAttrs.version;
    hash = "sha256-sBSIcQHL1FtWmn/1ra1GgeGFzO882UMr467fEfEcG2U=";
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
