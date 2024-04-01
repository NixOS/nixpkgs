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
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "serebit";
    repo = "waycheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kwkdTMA15oJHz9AXEkBGeuzYdEUpNuv/xnhzoKOHCE4=";
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

  meta = {
    description = "Simple GUI that displays the protocols implemented by a Wayland compositor";
    homepage = "https://gitlab.freedesktop.org/serebit/waycheck";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ julienmalka federicoschonborn ];
    mainProgram = "waycheck";
    platforms = lib.platforms.linux;
  };
})
