{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  qt6,
  wayland,
  glib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waycheck";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "serebit";
    repo = "waycheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-82jOYWhgD9JNDn24eCAeMm63R5BTy20lQVpiAwhDIOk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    glib
    wayland
    qt6.qtwayland
  ];

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace scripts/mesonPostInstall.sh \
      --replace-fail "#!/usr/bin/env sh" "#!${stdenv.shell}" \
      --replace-fail "update-desktop-database -q" "update-desktop-database $out/share/applications"
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Simple GUI that displays the protocols implemented by a Wayland compositor";
    homepage = "https://gitlab.freedesktop.org/serebit/waycheck";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ julienmalka ];
    mainProgram = "waycheck";
    platforms = lib.platforms.linux;
  };
})
