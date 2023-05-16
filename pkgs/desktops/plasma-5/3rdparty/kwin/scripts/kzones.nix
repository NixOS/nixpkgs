{ lib
<<<<<<< HEAD
, stdenv
=======
, mkDerivation
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
}:

<<<<<<< HEAD
stdenv.mkDerivation(finalAttrs: {
  pname = "kzones";
  version = "0.6";
=======
mkDerivation rec {
  pname = "kzones";
  version = "0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OAgzuX05dvotjRWiyPPeUieVJbQoy/opGYu6uVKQM60=";
  };

  nativeBuildInputs = [ plasma-framework ];

=======
    rev = "v${version}";
    sha256 = "sha256-E5pi2ttar6bAt7s0m/NCw66Qgg5fL5p5QpXROWuUTvM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
  ];

  dontBuild = true;

<<<<<<< HEAD
  # we don't have anything to wrap anyway
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    plasmapkg2 --type kwinscript --install ${finalAttrs.src} --packageroot $out/share/kwin/scripts
    install -Dm644 ${finalAttrs.src}/metadata.desktop $out/share/kservices5/kwin-script-kzones.desktop
=======
    plasmapkg2 --type kwinscript --install ${src} --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/metadata.desktop $out/share/kservices5/kwin-script-kzones.desktop
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    description = "KWin Script for snapping windows into zones";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    inherit (finalAttrs.src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
})
=======
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
