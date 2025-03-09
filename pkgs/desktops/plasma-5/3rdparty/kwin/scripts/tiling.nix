{
  lib,
  mkDerivation,
  fetchFromGitHub,
  kcoreaddons,
  kwindowsystem,
  plasma-framework,
  systemsettings,
}:

mkDerivation rec {
  pname = "kwin-tiling";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "kwin-scripts";
    repo = "kwin-tiling";
    rev = "v${version}";
    sha256 = "095slpvipy0zcmbn0l7mdnl9g74jaafkr2gqi09b0by5fkvnbh37";
  };

  # This is technically not needed, but we might as well clean up
  postPatch = ''
    rm release.sh
  '';

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
    install -Dm644 ${src}/metadata.desktop $out/share/kservices5/kwin-script-tiling.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tiling script for kwin";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
