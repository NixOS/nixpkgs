{
  stdenv,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchurl,
  libX11,
  libXpm,
  libXt,
  motif,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "xbill";
  version = "2.1";

  nativeBuildInputs = [
    autoreconfHook
    copyDesktopItems
  ];
  buildInputs = [
    libX11
    libXpm
    libXt
    motif
  ];

  NIX_CFLAGS_LINK = "-lXpm";

  configureFlags = [
    "--with-x"
    "--enable-motif"
  ];

  src = fetchurl {
    url = "http://www.xbill.org/download/${pname}-${version}.tar.gz";
    hash = "sha256-Dv3/8c4t9wt6FWActIjNey65GNIdeOh3vXc/ESlFYI0=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "xbill";
      exec = "xbill";
      icon = "xbill";
      desktopName = "XBill";
      comment = "Get rid of those Wingdows viruses!";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  makeFlags = "-B";

  postInstall = ''
    install -Dm644 pixmaps/icon.xpm $out/share/pixmaps/xbill.xpm
  '';

  meta = {
    description = "Protect a computer network from getting infected";
    homepage = "http://www.xbill.org/";
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ aw ];
    longDescription = ''
      Ever get the feeling that nothing is going right? You're a sysadmin,
      and someone's trying to destroy your computers. The little people
      running around the screen are trying to infect your computers with
      Wingdows [TM], a virus cleverly designed to resemble a popular
      operating system.
    '';
    mainProgram = "xbill";
  };
}
