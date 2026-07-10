{
  lib,
  stdenv,
  fetchzip,
  wrapGAppsHook3,
  wxwidgets_3_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wxedid";
  version = "0.0.33";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/project/wxedid/wxedid-${finalAttrs.version}.tar.gz";
    hash = "sha256-ShO2e5rQCVBdgyg4iiFzFEywl2m9A+jILMGI+MT8qgo=";
  };
  nativeBuildInputs = [
    wrapGAppsHook3
  ];
  buildInputs = [
    wxwidgets_3_3
  ];
  prePatch = ''
    patchShebangs src/rcode/rcd_autogen
  '';

  meta = {
    description = "wxWidgets-based EDID (Extended Display Identification Data) editor";
    homepage = "https://sourceforge.net/projects/wxedid";
    license = lib.licenses.gpl3Only;
    mainProgram = "wxedid";
    maintainers = [ lib.maintainers.meanwhile131 ];
    platforms = lib.platforms.linux;
  };
})
