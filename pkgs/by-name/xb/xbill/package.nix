{
  stdenv,
  lib,
  autoreconfHook,
  makeDesktopItem,
  copyDesktopItems,
  fetchpatch,
  fetchurl,
  libX11,
  libXpm,
  libXt,
  motif,
}:

stdenv.mkDerivation rec {
  pname = "xbill";
  version = "2.1";

  nativeBuildInputs = [
    autoreconfHook # Fix configure script that fails basic compilation check
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

  # xbill requires strcasecmp and strncasecmp but is missing proper includes
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/7c2c329a5a80781a9aaca24221675a0db66fd244/games-arcade/xbill/files/xbill-2.1-clang16.patch";
      hash = "sha256-Eg8qbSOdUoENcYruH6hSVIHcORkJeP8FXvp09cj/IXA=";
    })
  ];

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

  postInstall = ''
    install -Dm644 pixmaps/icon.xpm $out/share/pixmaps/xbill.xpm
  '';

  meta = {
    description = "Protect a computer network from getting infected";
    homepage = "http://www.xbill.org/";
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [
      aw
      jonhermansen
    ];
    longDescription = ''
      Ever get the feeling that nothing is going right? You're a sysadmin,
      and someone's trying to destroy your computers. The little people
      running around the screen are trying to infect your computers with
      Wingdows [TM], a virus cleverly designed to resemble a popular
      operating system.
    '';
    mainProgram = "xbill";
    platforms = lib.platforms.unix;
  };
}
