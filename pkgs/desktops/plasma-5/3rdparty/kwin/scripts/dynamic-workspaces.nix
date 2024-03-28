{ lib
, mkDerivation
, fetchFromGitHub
, kcoreaddons
, kwindowsystem
, plasma-framework
, systemsettings
}:

mkDerivation rec {
  pname = "dynamic_workspaces";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "d86leader";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qYoWUj41tx/cwP6yCAORuwIan9Z5NDRU6DK1leWHcIw=";
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
    install -Dm644 ${src}/metadata.desktop $out/share/kservices5/dynamic_workspaces.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "KWin script that automatically adds/removes virtual desktops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
