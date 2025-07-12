{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
  motif,
  openssl,
  groff,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xephem";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "XEphem";
    repo = "XEphem";
    rev = version;
    hash = "sha256-TuzXrWoJOAHg31DrJObPcHBXgtqR/KWKFRsqddPzL4c=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
    groff # nroff
  ];

  buildInputs = [
    motif
    openssl
    xorg.libXmu
    xorg.libXext
    xorg.libXt
  ];

  patches = [
    # fix compile error with GCC 14
    (fetchpatch {
      url = "https://github.com/XEphem/XEphem/commit/30e14f685ede015fcd8985cd83ee6510f93f0073.patch";
      hash = "sha256-wNoLjR6xEl56ZA6FLBS2xtySeDEYXTCA8j4Z5JIrF6k=";
    })
    ./add-cross-compilation-support.patch
  ];

  postPatch = ''
    cd GUI/xephem
    substituteInPlace xephem.c splash.c --replace-fail '/etc/XEphem' '${placeholder "out"}/etc/XEphem'
  '';

  doCheck = true;

  checkFlags = "-C ../../tests";

  checkTarget = "run-test";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ];

  installPhase = ''
    runHook preInstall
    installBin xephem
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
    install -Dm644 XEphem.png -t $out/share/pixmaps
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
    description = "Interactive astronomy program for all UNIX platforms";
    longDescription = ''
      Xephem is an interactive astronomical ephemeris program for X Windows systems. It computes
      heliocentric, geocentric and topocentric information for fixed celestial objects and objects
      in heliocentric and geocentric orbits; has built-in support for all planet positions; the
      moons of Jupiter, Saturn and Earth; Mars' and Jupiter's central meridian longitude; Saturn's
      rings; and Jupiter's Great Red Spot.
    '';
    mainProgram = "xephem";
    homepage = "https://xephem.github.io/XEphem/Site/xephem.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ EstebanMacanek ];
    platforms = lib.platforms.unix;
  };
}
