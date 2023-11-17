{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, qt6
, wayland
, glib
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waycheck";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "serebit";
    repo = "waycheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oGpiFwbPBQHF0wRHliltU8B+QmClcoFfbjpAYzOFPqs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    glib
    wayland
    qt6.qtwayland
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  preInstall = ''
    substituteInPlace ../scripts/mesonPostInstall.sh \
      --replace "update-desktop-database -q" "update-desktop-database $out/share/applications"
  '';

  meta = with lib; {
    description = "Simple GUI that displays the protocols implemented by a Wayland compositor";
    homepage = "https://gitlab.freedesktop.org/serebit/waycheck";
    license = licenses.asl20;
    maintainers = with maintainers; [ julienmalka federicoschonborn ];
    mainProgram = "waycheck";
    platforms = platforms.linux;
  };
})
