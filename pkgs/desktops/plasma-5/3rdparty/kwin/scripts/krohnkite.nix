{ lib
, mkDerivation
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
}:

mkDerivation rec {
  pname = "krohnkite";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = version;
    hash = "sha256-8A3zW5tK8jK9fSxYx28b8uXGsvxEoUYybU0GaMD2LNw=";
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

    plasmapkg2 --type kwinscript --install ${src}/res/ --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/res/metadata.desktop $out/share/kservices5/krohnkite.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynamic tiling extension for KWin";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
