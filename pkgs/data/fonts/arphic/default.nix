{ lib, fetchzip, mkfontscale, mkfontdir }:

let
  version = "0.2.20080216.2";
in {
  arphic-ukai = fetchzip {
    name = "arphic-ukai-${version}";

    url = "mirror://ubuntu/pool/main/f/fonts-arphic-ukai/fonts-arphic-ukai_${version}.orig.tar.bz2";

    postFetch = ''
      tar -xjvf $downloadedFile --strip-components=1
      install -D -v ukai.ttc $out/share/fonts/truetype/arphic-ukai.ttc
      cd $out/share/fonts
      ${mkfontdir}/bin/mkfontdir
      ${mkfontscale}/bin/mkfontscale
    '';

    sha256 = "0xi5ycm7ydzpn7cqxv1kcj9vd70nr9wn8v27hmibyjc25y2qdmzl";

    meta = with lib; {
      description = "CJK Unicode font Kai style";
      homepage = "https://www.freedesktop.org/wiki/Software/CJKUnifonts/";

      license = licenses.arphicpl;
      maintainers = [ maintainers.changlinli ];
      platforms = platforms.all;
    };
  };

  arphic-uming = fetchzip {
    name = "arphic-uming-${version}";

    url = "mirror://ubuntu/pool/main/f/fonts-arphic-uming/fonts-arphic-uming_${version}.orig.tar.bz2";

    postFetch = ''
      tar -xjvf $downloadedFile --strip-components=1
      install -D -v uming.ttc $out/share/fonts/truetype/arphic-uming.ttc
      cd $out/share/fonts
      ${mkfontdir}/bin/mkfontdir
      ${mkfontscale}/bin/mkfontscale
    '';

    sha256 = "16jybvj1cxamm682caj6nsm6l5c60x9mgchp1l2izrw2rvc8x38d";

    meta = with lib; {
      description = "CJK Unicode font Ming style";
      homepage = "https://www.freedesktop.org/wiki/Software/CJKUnifonts/";

      license = licenses.arphicpl;
      maintainers = [ maintainers.changlinli ];
      platforms = platforms.all;
    };
  };
}
