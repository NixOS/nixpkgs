{ lib
, stdenv
, fetchurl

, fribidi
, gnutls
, gtk2
, libxml2
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "tickr";
  version = "0.7.1";

  src = fetchurl {
    url = "http://www.open-tickr.net/src/tickr-${version}.tar.gz";
    hash = "sha256-ORUpoRW4INXCyse0ZvrMRyK3+Q4CqwrNc1Co6Xrc7lg=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fribidi
    gnutls
    gtk2
    libxml2
  ];

  postPatch = ''
    substituteInPlace src/tickr/tickr.h \
        --replace-fail "/usr/share" "$out/share"
  '';

  # -Wformat is required by -Wsecurity-format
  makeFlags = [ "CFLAGS=-Wformat" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/64x64/apps
    mkdir -p $out/share/tickr/pixmaps

    cp -r src/tickr/tickr $out/bin
    cp -r tickr.desktop $out/share/applications/tickr.desktop
    cp -r images/tickr-icon.* imags/tickr-rss-icon.* $out/share/tickr/pixmaps
    ln -s $out/share/tickr/pixmaps/tickr-icon.png $out/share/icons/hicolor/64x64/apps/tickr-icon.png

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/tickr.desktop \
        --replace-fail "/usr/bin" "$out/bin" \
        --replace-fail "/usr/share" "$out/share"
  '';

  meta = {
    description = "A GTK-based highly graphically-customizable Feed Ticker";
    homepage = "http://www.open-tickr.net";
    changelog = "https://www.open-tickr.net/history.php";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "tickr";
    maintainers = with lib.maintainers; [ oo-infty ];
  };
}
