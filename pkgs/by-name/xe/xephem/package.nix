{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
  motif,
  openssl,
  groff,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xephen";
  version = "4.2.0";

  buildInputs = [
    motif
    openssl
    groff
    xorg.libXmu
    xorg.libXext
    xorg.libXt
  ];

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
  ];

  src = fetchFromGitHub {
    owner = "XEphem";
    repo = "XEphem";
    rev = version;
    hash = "sha256-TuzXrWoJOAHg31DrJObPcHBXgtqR/KWKFRsqddPzL4c=";
  };

  postPatch = ''
    cd GUI/xephem
    sed -i "s|/etc/XEphem|$out/etc/XEphem|" xephem.c
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 xephem -t $out/bin
    mkdir -p $out/share/xephem
    cp -R auxil $out/share/xephem/
    cp -R catalogs $out/share/xephem/
    cp -R fifos $out/share/xephem/
    cp -R fits $out/share/xephem/
    cp -R gallery $out/share/xephem/
    cp -R help $out/share/xephem/
    cp -R lo $out/share/xephem/
    mkdir $out/etc
    echo "XEphem.ShareDir: $out/share/xephem" > $out/etc/XEphem
    installManPage xephem.1
    install -Dm644 XEphem.png -t $out/share/icons
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "xephem";
      exec = "xephem";
      icon = "XEphem";
      desktopName = "XEphem";
      categories = [
        "Science"
        "Astronomy"
      ];
    })
  ];

  meta = {
    description = "The Serious Interactive Astronomical Software Ephemeris";
    mainProgram = "xephem";
    homepage = "https://xephem.github.io/XEphem/Site/xephem.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ EstebanMacanek ];
    platforms = lib.platforms.unix;
  };
}
