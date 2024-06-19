{ lib
, stdenv
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "kzones";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OAgzuX05dvotjRWiyPPeUieVJbQoy/opGYu6uVKQM60=";
  };

  nativeBuildInputs = [ plasma-framework ];

  buildInputs = [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
  ];

  dontBuild = true;

  # we don't have anything to wrap anyway
  dontWrapQtApps = true;

  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall

    plasmapkg2 --type kwinscript --install ${finalAttrs.src} --packageroot $out/share/kwin/scripts
    install -Dm644 ${finalAttrs.src}/metadata.desktop $out/share/kservices5/kwin-script-kzones.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "KWin Script for snapping windows into zones";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3Plus;
    inherit (finalAttrs.src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
})
