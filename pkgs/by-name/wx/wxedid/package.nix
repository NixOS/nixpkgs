{
  lib,
  stdenv,
  fetchzip,
  wrapGAppsHook3,
  wxwidgets_3_3,
}:
stdenv.mkDerivation rec {
  pname = "wxedid";
  version = "0.0.33";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/project/wxedid/wxedid-${version}.tar.gz";
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

  meta = with lib; {
    description = "wxWidgets-based EDID (Extended Display Identification Data) editor";
    homepage = "https://sourceforge.net/projects/wxedid";
    license = licenses.gpl3Only;
    mainProgram = "wxedid";
    maintainers = [ maintainers.meanwhile131 ];
    platforms = lib.platforms.linux;
  };
}
