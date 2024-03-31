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
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "serebit";
    repo = "waycheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sDfIR+F2W59mh50jXoOrcNZ1nuckm3r7jN613BH4Eog=";
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
    maintainers = with lib.maintainers; [ julienmalka federicoschonborn ];
    mainProgram = "waycheck";
    platforms = lib.platforms.linux;
  };
})
