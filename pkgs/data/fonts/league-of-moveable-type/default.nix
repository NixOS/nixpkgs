{stdenv, fetchurl, unzip, raleway}:

let

  # TO UPDATE:
  # ./update.sh > ./fonts.nix
  # we use the extended version of raleway (same license).
  fonts = [raleway]
    ++ map fetchurl (builtins.filter (f: f.name != "raleway.zip") (import ./fonts.nix));

in
stdenv.mkDerivation rec {

  baseName = "league-of-moveable-type";
  version = "2016-10-15";
  name="${baseName}-${version}";

  srcs = fonts;

  buildInputs = [ unzip ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp */*.otf $out/share/fonts/opentype
    # for Raleway, where the fonts are already in /share/…
    cp */share/fonts/opentype/*.otf $out/share/fonts/opentype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1gy959qhhdwm1phbrkab9isi0dmxcy0yizzncb0k49w88mc13vd0";

  meta = {
    description = "Font Collection by The League of Moveable Type";

    longDescription = '' We're done with the tired old fontstacks of
      yesteryear. The web is no longer limited, and now it's time to raise
      our standards. Since 2009, The League has given only the most
      well-made, free & open-source, @font-face ready fonts.
    '';

    homepage = https://www.theleagueofmoveabletype.com/;

    license = stdenv.lib.licenses.ofl;

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ bergey profpatsch ];
  };
}
