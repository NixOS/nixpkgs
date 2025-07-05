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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waycheck";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "serebit";
    repo = "waycheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wO3+Vwi4wM/NfRdHUt0AVEE6UPr7wkY12JBVzLFqM4c=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple GUI that displays the protocols implemented by a Wayland compositor";
    homepage = "https://gitlab.freedesktop.org/serebit/waycheck";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      julienmalka
      pandapip1
    ];
    mainProgram = "waycheck";
    platforms = lib.platforms.linux;
  };
})
