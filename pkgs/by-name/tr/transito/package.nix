{
  lib,
  stdenv,
  buildGoModule,
  fetchFromSourcehut,
  pkg-config,
  vulkan-headers,
  libxkbcommon,
  wayland,
  xorg,
  libGL,
  sqlite,
}:

buildGoModule rec {
  pname = "transito";
  version = "0.10.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "transito";
    rev = "v${version}";
    hash = "sha256-87U9RdlP260ApkGJB3dLitxAdY3I9nWrukxzRnwuJ2E=";
  };
  vendorHash = "sha256-mgvfrNKvdjLa7O0oTSec8u3eHHU66ZDqpKzNeeyy2J0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    vulkan-headers
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
    xorg.libxcb
    libGL
    sqlite
  ];

  tags = [ "sqlite_math_functions" ];
  ldflags = [ "-X git.sr.ht/~mil/transito/src/uipages/pageconfig.Commit=${version}" ];

  postInstall = ''
    install -Dm644 -t $out/share/applications assets/transito.desktop
    install -Dm644 -t $out/share/pixmaps assets/transito.png
    for icon in assets/transito_*.png
    do
      name=$(basename $icon .png)
      install -Dm644 -t $out/share/icons/hicolor/''${name#transito_}/apps $icon
    done
  '';

  doCheck = false; # no test

  meta = with lib; {
    description = "Data-provider-agnostic (GTFS) public transportation app";
    longDescription = ''
      Transito is a data-provider-agnostic public transportation app
      that let's you route between locations using openly available
      public GTFS feeds.  Utilizing the Mobroute library,
      the Transito app lets you performs routing calculations offline
      (no network calls once data is initially fetched).

      Overall, Transito aims to be an opensource alternative
      to proprietary routing apps to get users from point A to point B
      via public transit without comprising privacy or user freedoms.
      It works in many well-connected metros which have publicly available
      GTFS data, to name a few: Lisbon, NYC, Brussels, Krakow, and Bourges.
    '';
    homepage = "https://git.sr.ht/~mil/transito";
    changelog = "https://git.sr.ht/~mil/transito/refs/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.McSinyx ];
    mainProgram = "transito";
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
