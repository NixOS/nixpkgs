{ lib
, mkDerivation
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
}:

mkDerivation rec {
  pname = "parachute";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tcorreabr";
    repo = "parachute";
    rev = "v${version}";
    sha256 = "QIWb1zIGfkS+Bef7LK+JA6XpwGUW+79XZY47j75nlCE=";
  };

  buildInputs = [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
  ];

  dontBuild = true;

  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall
    plasmapkg2 --type kwinscript --install ${src} --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/metadata.desktop $out/share/kservices5/Parachute.desktop
    runHook postInstall
  '';

  meta = with lib; {
    description = "Look at your windows and desktops from above";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
