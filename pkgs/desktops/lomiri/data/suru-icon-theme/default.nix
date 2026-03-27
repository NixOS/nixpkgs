{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  gitUpdater,
  gtk3,
  hicolor-icon-theme,
  ubuntu-themes,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suru-icon-theme";
  version = "2025.05.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/suru-icon-theme";
    rev = finalAttrs.version;
    hash = "sha256-6MyZTRcfCpiCXzwrwNiBP6J4L4oFbFtoymhke13tLy0=";
  };

  # Commit 79763fa4ff701d1d89d7362c37c65b2a3cbdf543 introduced abunch of symlinks for Lomiri apps' icons to files from this theme.
  # This seems to have broken Lomiri, as it now gets stuck during startup (presumably?) trying to resolve the icons of these apps in the sidebar.
  # Can't apply a revert of the commit because patch refuses to touch symlinks.
  postPatch = ''
    for app in dekko2 lomiri-{addressbook,calculator,calendar,camera,clock,dialer,docviewer,gallery,mediaplayer,messaging,music,notes,terminal,weather}-app lomiri-system-settings lomiri-online-accounts-{facebook,flickr,google,owncloud,twitter,ubuntuones,yahoo}; do
      find suru/apps -name "$app".png -exec rm -v {} \;
      find suru/apps -name "$app"-symbolic.svg -exec rm -v {} \;
    done
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gtk3 # gtk-update-icon-cache
    hicolor-icon-theme # theme setup hook
  ];

  propagatedBuildInputs = [ ubuntu-themes ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r suru $out/share/icons/

    gtk-update-icon-cache $out/share/icons/suru

    runHook postInstall
  '';

  dontDropIconThemeCache = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Suru Icon Theme for Lomiri Operating Environment";
    homepage = "https://gitlab.com/ubports/development/core/suru-icon-theme";
    changelog = "https://gitlab.com/ubports/development/core/suru-icon-theme/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.cc-by-sa-30;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.all;
  };
})
