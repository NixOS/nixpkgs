{
  lib,
  stdenvNoCC,
  fetchzip,
  symlinkJoin,
}:

let
  fonts = {
    # Sometimes "a" in version is missing in the URL
    koburimin = {
      version = "6.1a";
      url = "https://okoneya.jp/font/GenEiKoburiMin_v6.1.zip";
      hash = "sha256-pLgCiK+o6tssPoZnxbKsSfYV4J7bHfz12hynuC3zC2g=";
    };
    chikumin = {
      version = "3.1a";
      url = "https://okoneya.jp/font/GenEiChikuMin_v3.1.zip";
      hash = "sha256-WqWB5bVErd0I8QDEipDxzd5PbZ08NsLnBLXygLTcC2I=";
    };
    antique = {
      version = "5.1";
      url = "https://okoneya.jp/font/GenEiAntique_v5.1.zip";
      hash = "sha256-1HUbD4tBWp17+rF8+XqQ9FngazRnfe6kpId/mjyNX10=";
    };
    eimgothic = {
      version = "2.0";
      url = "https://okoneya.jp/font/GenEiMGothic_v2.0.zip";
      hash = "sha256-AdZcvR2NAc1BBWGAzrZQNiRIqGVVjUSK7Zr9sIbWW2Q=";
    };
    pople = {
      version = "1.0";
      url = "https://okoneya.jp/font/GenEiPOPle_v1.0.zip";
      hash = "sha256-DZ2rVoEdUwnxXRxFs0wmQOovBBeQt/iSUNYCou9Stuc=";
    };
    kiwamigo = {
      version = "1.2";
      url = "https://okoneya.jp/font/GenEiKiwamiGo_v1.2.zip";
      hash = "sha256-F8L5MkpRjKgXBE3TaKY9PcKCrEpecL0QIoEVTAWBGNg=";
    };
    monogothic = {
      version = "1.0";
      url = "https://okoneya.jp/font/GenEiMonoGothic_v1.0.zip";
      hash = "sha256-4cNoLihaO4xLf3z2o+8pgwQ0sJ+T+wJsOG9N5oyxOVY=";
    };
    nugothic-eb = {
      version = "1.1";
      url = "https://okoneya.jp/font/GenEiNuGothic-EB_v1.1.zip";
      hash = "sha256-hzUAp4sYuuGnCD0ZSdxRodWBWx6kh024fHadJ5z5wik=";
    };
    latin = {
      version = "2.1";
      url = "https://okoneya.jp/font/GenEiLatin-Separate_v2.1.zip";
      hash = "sha256-pLgCiK+o6tssPoZnxbKsSfYV4J7bHfz12hynuC3zC2g=";
    };
    universans = {
      version = "1.1";
      url = "https://okoneya.jp/font/GenEiUniverSans-1.1.zip";
      hash = "sha256-B+1tFzJhVgGP3auwF6h/t6RU78xomI68MNu9wFxuUVk=";
    };
    webhonmon = {
      version = "1.0";
      url = "https://okoneya.jp/font/GenEiWebHonmon_v1.0.zip";
      hash = "sha256-uNm39uHbcFYyKAtmf+kr5WlJWazYL0A92jjg1oTCsQg=";
    };
    nombre = {
      version = "2.0";
      url = "https://okoneya.jp/font/GenEiNombre_v2.0.zip";
      hash = "sha256-dNftKdwp6+JmFri09I2AuqucH6nTPlkOq86lKMNow4Q=";
    };
    brice = {
      version = "1.1";
      url = "https://okoneya.jp/font/GenEiBrice_v1.1.zip";
      hash = "sha256-HzFrN3VmLyVtZ18e+Hz/6/Y3yfHJB3WVx67JQciujx4=";
    };
    romannotes = {
      version = "1.0";
      url = "https://okoneya.jp/font/GenEiRomanNotes-1.0.zip";
      hash = "sha256-QCDIunaVo8ppl/P2nC/iwj0yLOm45igQLT4GM18ARGI=";
    };
    bizenantique = {
      version = "1.0";
      url = "https://okoneya.jp/font/BIZenAntique.zip";
      hash = "sha256-x9navGNGlPY0p7o+6wNQx8QZwNHMUKQMHja0wZk1V24=";
    };
    togemarugothic = {
      version = "1.0";
      url = "https://okoneya.jp/font/TogeMaruGothic_v1.0.zip";
      hash = "sha256-L3Q3sMJYUXJYL/eOmAreRSjqdyDDH/h82dQhZlCv/KQ=";
    };
    satsukigendaimincho = {
      version = "1.04";
      url = "https://okoneya.jp/font/SatsukiGendaiMincho_v1.04.zip";
      hash = "sha256-SgJfX/Jd2n/mbM0xYRbNuivRILjv1Wu7Jxx8VSpvbtw=";
    };
    gothicall = {
      version = "1.1a";
      url = "https://okoneya.jp/font/GenEiGothicAll-1.1a.zip";
      hash = "sha256-Vgk3XTHNYxYxtBtuRWqs7t/hGjPGcRUquV4sB/N6JFc=";
    };
    gothickl = {
      version = "1.3";
      url = "https://okoneya.jp/font/GenEiGothicKL-1.3.zip";
      hash = "sha256-1YpFMjd6NFR0lv8GkJv78T+Uxw/sgekyHFCAHBWV10c=";
    };
  };

  mkpkg =
    pname:
    {
      version,
      url,
      hash,
    }:
    stdenvNoCC.mkDerivation rec {
      inherit pname version;

      src = fetchzip {
        inherit hash url;
      };

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/{fonts/opentype,fonts/truetype,doc/genei-${pname}}
        find . -type f -name "*.otf" -exec cp -v {} $out/share/fonts/opentype/ \;
        find . -type f -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype/ \;
        find . -type f -name "*.txt" -exec cp -v {} $out/share/doc/genei-${pname}/ \;

        runHook postInstall
      '';

      meta = {
        homepage = "https://okoneya.jp/font/";
        description = "Japanese text fonts modified from Source Han Sans JP";
        license = lib.licenses.ofl;
        platforms = lib.platforms.linux;
        maintainers = with lib.maintainers; [
          _34j
        ];
      };
    };
  packages = lib.mapAttrs mkpkg fonts;
in
packages
// {
  full = symlinkJoin {
    name = "full";
    paths = builtins.filter lib.isDerivation (lib.attrValues packages);
  };
}
