{ stdenv, fetchurl, mkfontscale, mkfontdir }:

{
  arphic-ukai = stdenv.mkDerivation rec {
    name = "arphic-ukai-${version}";

    version = "0.2.20080216.2";

    src = fetchurl {
      url = "http://archive.ubuntu.com/ubuntu/pool/main/f/fonts-arphic-ukai/fonts-arphic-ukai_${version}.orig.tar.bz2";
      sha256 = "1lp3i9m6x5wrqjkh1a8vpyhmsrhvsa2znj2mx13qfkwza5rqv5ml";
    };

    buildInputs = [ mkfontscale mkfontdir ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      install -D -v ukai.ttc $out/share/fonts/truetype/arphic-ukai.ttc
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

    meta = with stdenv.lib; {
      description = "CJK Unicode font Kai style";
      homepage = https://www.freedesktop.org/wiki/Software/CJKUnifonts/;

      license = licenses.arphicpl;
      maintainers = [ maintainers.changlinli ];
      platforms = platforms.all;
    };
  };

  arphic-uming = stdenv.mkDerivation rec {
    name = "arphic-uming-${version}";

    version = "0.2.20080216.2";

    src = fetchurl {
      url = "http://archive.ubuntu.com/ubuntu/pool/main/f/fonts-arphic-uming/fonts-arphic-uming_${version}.orig.tar.bz2";
      sha256 = "1ny11n380vn7sryvy1g3a83y3ll4h0jf9wgnrx55nmksx829xhg3";
    };

    buildInputs = [ mkfontscale mkfontdir ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      install -D -v uming.ttc $out/share/fonts/truetype/arphic-uming.ttc
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

    meta = with stdenv.lib; {
      description = "CJK Unicode font Ming style";
      homepage = https://www.freedesktop.org/wiki/Software/CJKUnifonts/;

      license = licenses.arphicpl;
      maintainers = [ maintainers.changlinli ];
      platforms = platforms.all;
    };
  };
}
