{ lib, mkDerivation, fetchFromGitHub
, kcoreaddons, kwindowsystem, plasma-framework, systemsettings }:

mkDerivation rec {
  pname = "kzones";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${version}";
    sha256 = "sha256-o7ItUHPayR0wnySssWvtVAaMRa9A1m778FY500hXHXQ=";
  };

  buildInputs = [
    kcoreaddons kwindowsystem plasma-framework systemsettings
  ];

  dontBuild = true;

  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall

    plasmapkg2 --type kwinscript --install ${src} --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/metadata.desktop $out/share/kservices5/kwin-script-kzones.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "KWin Script for snapping windows into zones";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3Plus;
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}

