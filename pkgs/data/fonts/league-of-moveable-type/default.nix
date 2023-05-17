{ lib
, symlinkJoin
, the-neue-black
, blackout
, chunk
, fanwood
, goudy-bookletter-1911
, junction-font
, knewave
, league-gothic
, league-script-number-one
, league-spartan
, linden-hill
, orbitron
, ostrich-sans
, prociono
, raleway
, sniglet
, sorts-mill-goudy
}:

symlinkJoin {
  name = "league-of-moveable-type";

  paths = [
    the-neue-black
    blackout
    chunk
    fanwood
    goudy-bookletter-1911
    junction-font
    knewave
    league-gothic
    league-script-number-one
    league-spartan
    linden-hill
    orbitron
    ostrich-sans
    prociono
    raleway
    sniglet
    sorts-mill-goudy
  ];

  meta = {
    description = "Font Collection by The League of Moveable Type";

    longDescription = ''
      We're done with the tired old fontstacks of yesteryear. The web
      is no longer limited, and now it's time to raise our standards.
      Since 2009, The League has given only the most well-made, free &
      open-source, @font-face ready fonts.
    '';

    homepage = "https://www.theleagueofmoveabletype.com/";

    license = lib.licenses.ofl;

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey minijackson Profpatsch ];
  };
}
