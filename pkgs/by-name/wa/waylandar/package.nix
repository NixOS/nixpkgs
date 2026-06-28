{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  quickshell,
  writeShellScriptBin,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.google-api-python-client
    ps.google-auth-httplib2
    ps.google-auth-oauthlib
    ps.caldav
    ps.icalendar
    ps.recurring-ical-events
    ps.cryptography
  ]);

  initTheme = writeShellScriptBin "waylandar-init-theme" ''
    share="$(dirname "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")")/share/waylandar"

    if [ -f ~/.config/waylandar/frontend/Theme.qml ]; then
      cp ~/.config/waylandar/frontend/Theme.qml ~/.config/waylandar/Theme.qml.bak
    fi
    rm -rf ~/.config/waylandar/frontend
    mkdir -p ~/.config/waylandar/frontend/components

    ln -sfn "$share"/frontend/*.qml ~/.config/waylandar/frontend/ 2>/dev/null || true
    ln -sfn "$share"/frontend/components/*.qml ~/.config/waylandar/frontend/components/ 2>/dev/null || true

    if [ -f ~/.config/waylandar/Theme.qml.bak ]; then
      mv ~/.config/waylandar/Theme.qml.bak ~/.config/waylandar/frontend/Theme.qml
    fi

    cp "$share"/theme_template.qml ~/.config/waylandar/theme_template.qml
    chmod 644 ~/.config/waylandar/theme_template.qml

    if [ ! -f ~/.config/waylandar/frontend/Theme.qml ]; then
      cp "$share"/fallback_Theme.qml ~/.config/waylandar/frontend/Theme.qml
      chmod 644 ~/.config/waylandar/frontend/Theme.qml
    fi
  '';

  waylandarCli = writeShellScriptBin "waylandar" ''
    share="$(dirname "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")")/share/waylandar"
    exec ${pythonEnv}/bin/python "$share/backend/sync.py" "$@"
  '';

  waylandarWidget = writeShellScriptBin "waylandar-widget" ''
    binDir="$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")"
    source "$binDir/waylandar-init-theme"
    exec ${quickshell}/bin/quickshell -p ~/.config/waylandar/frontend/widget.qml
  '';

  waylandarDashboard = writeShellScriptBin "waylandar-dashboard" ''
    binDir="$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")"
    source "$binDir/waylandar-init-theme"
    exec ${quickshell}/bin/quickshell -p ~/.config/waylandar/frontend/dashboard.qml
  '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "waylandar";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "samjoshuadud";
    repo = "waylandar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-axRpXgeuTqHWgz56EbWKPj4q2yNaLnVs/UXSuY3NxvM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/waylandar

    cp -r frontend backend theme_template.qml $out/share/waylandar/

    # Move Theme.qml out of frontend so it is not symlinked as read-only
    mv $out/share/waylandar/frontend/Theme.qml $out/share/waylandar/fallback_Theme.qml

    # Remove qmldir from installed frontend
    rm -f $out/share/waylandar/frontend/qmldir

    # Install scripts
    cp ${initTheme}/bin/waylandar-init-theme $out/bin/waylandar-init-theme
    cp ${waylandarCli}/bin/waylandar $out/bin/waylandar
    cp ${waylandarWidget}/bin/waylandar-widget $out/bin/waylandar-widget
    cp ${waylandarDashboard}/bin/waylandar-dashboard $out/bin/waylandar-dashboard

    runHook postInstall
  '';

  meta = {
    description = "Standalone Wayland calendar widget and dashboard built with Quickshell and Python";
    longDescription = ''
      Waylandar is a standalone Wayland calendar widget and dashboard that
      supports Google Calendar, Nextcloud (CalDAV), Apple iCloud, ICS feed
      subscriptions, and local .ics directories. It features background sync
      with desktop notifications and optional Matugen theming integration.
    '';
    homepage = "https://github.com/samjoshuadud/waylandar";
    changelog = "https://github.com/samjoshuadud/waylandar/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samjoshuadud ];
    platforms = lib.platforms.linux;
    mainProgram = "waylandar-widget";
  };
})
