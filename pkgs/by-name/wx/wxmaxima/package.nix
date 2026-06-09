{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  cmake,
  gettext,
  maxima,
  wxwidgets_3_2,
  adwaita-icon-theme,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxmaxima";
  version = "26.05.0";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${finalAttrs.version}";
    hash = "sha256-/O57UjejHb9lDYiLs9jdtmt/S7CTHY0tlq07fAxh5TM=";
  };

  buildInputs = [
    wxwidgets_3_2
    maxima
    # So it won't embed svg files into headers.
    adwaita-icon-theme
    # So it won't crash under Sway.
    glib
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    cmake
    gettext
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxwidgets_3_2}/lib"
  ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  meta = {
    description = "Cross platform GUI for the computer algebra system Maxima";
    mainProgram = "wxmaxima";
    license = lib.licenses.gpl2;
    homepage = "https://wxmaxima-developers.github.io/wxmaxima/";
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux;
  };
})
