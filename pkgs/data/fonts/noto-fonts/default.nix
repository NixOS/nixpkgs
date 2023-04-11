{ stdenv
, stdenvNoCC
, lib
, fetchFromGitHub
, fetchurl
, cairo
, nixosTests
, pkg-config
, pngquant
, which
, imagemagick
, zopfli
, buildPackages
, variants ? [ ]
}:
let
  notoLongDescription = ''
    When text is rendered by a computer, sometimes characters are
    displayed as “tofu”. They are little boxes to indicate your device
    doesn’t have a font to display the text.

    Google has been developing a font family called Noto, which aims to
    support all languages with a harmonious look and feel. Noto is
    Google’s answer to tofu. The name noto is to convey the idea that
    Google’s goal is to see “no more tofu”.  Noto has multiple styles and
    weights, and freely available to all.
  '';
in
rec {
  mkNoto =
    { pname
    , variants ? [ ]
    , longDescription ? notoLongDescription
    }:
    stdenvNoCC.mkDerivation rec {
      inherit pname;
      version = "23.4.1";

      src = fetchFromGitHub {
        owner = "notofonts";
        repo = "notofonts.github.io";
        rev = "noto-monthly-release-${version}";
        hash = "sha256-hiBbhcwktacuoYJnZcsh7Aej5QIrBNkqrel2NhjNjCU=";
      };

      _variants = map (variant: builtins.replaceStrings [ " " ] [ "" ] variant) variants;

      installPhase = ''
        # We check availability in order of variable -> otf -> ttf
        # unhinted -- the hinted versions use autohint
        # maintaining maximum coverage.
        #
        # We have a mix of otf and ttf fonts
        local out_font=$out/share/fonts/noto
      '' + (if _variants == [ ] then ''
        for folder in $(ls -d fonts/*/); do
          if [[ -d "$folder"unhinted/variable-ttf ]]; then
            install -m444 -Dt $out_font "$folder"unhinted/variable-ttf/*.ttf
          elif [[ -d "$folder"unhinted/otf ]]; then
            install -m444 -Dt $out_font "$folder"unhinted/otf/*.otf
          else
            install -m444 -Dt $out_font "$folder"unhinted/ttf/*.ttf
          fi
        done
      '' else ''
        for variant in $_variants; do
          if [[ -d fonts/"$variant"/unhinted/variable-ttf ]]; then
            install -m444 -Dt $out_font fonts/"$variant"/unhinted/variable-ttf/*.ttf
          elif [[ -d fonts/"$variant"/unhinted/otf ]]; then
            install -m444 -Dt $out_font fonts/"$variant"/unhinted/otf/*.otf
          else
            install -m444 -Dt $out_font fonts/"$variant"/unhinted/ttf/*.ttf
          fi
        done
      '');

      meta = with lib; {
        description = "Beautiful and free fonts for many languages";
        homepage = "https://www.google.com/get/noto/";
        inherit longDescription;
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ mathnerd314 emily jopejoe1 ];
      };
    };

  mkNotoCJK = { typeface, version, rev, sha256 }:
    stdenvNoCC.mkDerivation {
      pname = "noto-fonts-cjk-${lib.toLower typeface}";
      inherit version;

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-cjk";
        inherit rev sha256;
        sparseCheckout = [ "${typeface}/Variable/OTC" ];
      };

      installPhase = ''
        install -m444 -Dt $out/share/fonts/opentype/noto-cjk ${typeface}/Variable/OTC/*.otf.ttc
      '';

      passthru.tests.noto-fonts = nixosTests.noto-fonts;

      meta = with lib; {
        description = "Beautiful and free fonts for CJK languages";
        homepage = "https://www.google.com/get/noto/help/cjk/";
        longDescription = ''
          Noto ${typeface} CJK is a ${lib.toLower typeface} typeface designed as
          an intermediate style between the modern and traditional. It is
          intended to be a multi-purpose digital font for user interface
          designs, digital content, reading on laptops, mobile devices, and
          electronic books. Noto ${typeface} CJK comprehensively covers
          Simplified Chinese, Traditional Chinese, Japanese, and Korean in a
          unified font family. It supports regional variants of ideographic
          characters for each of the four languages. In addition, it supports
          Japanese kana, vertical forms, and variant characters (itaiji); it
          supports Korean hangeul — both contemporary and archaic.
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ mathnerd314 emily ];
      };
    };

  noto-fonts = mkNoto {
    pname = "noto-fonts";
  };

  noto-fonts-lgc-plus = mkNoto {
    pname = "noto-fonts-lgc-plus";
    variants = [
      "Noto Sans"
      "Noto Serif"
      "Noto Sans Mono"
      "Noto Music"
      "Noto Sans Symbols"
      "Noto Sans Symbols 2"
      "Noto Sans Math"
    ];
    longDescription = ''
      This package provides the Noto Fonts, but only for latin, greek
      and cyrillic scripts, as well as some extra fonts. To create a
      custom Noto package with custom variants, see the `mkNoto`
      helper function.
    '';
  };

  noto-fonts-cjk-sans = mkNotoCJK {
    typeface = "Sans";
    version = "2.004";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-PWpcTBnBRK87ZuRI/PsGp2UMQgCCyfkLHwvB1mOl5K0=";
  };

  noto-fonts-cjk-serif = mkNotoCJK {
    typeface = "Serif";
    version = "2.000";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-1w66Ge7DZjbONGhxSz69uFhfsjMsDiDkrGl6NsoB7dY=";
  };

  noto-fonts-emoji =
    let
      version = "2.038";
      emojiPythonEnv =
        buildPackages.python3.withPackages (p: with p; [ fonttools nototools ]);
    in
    stdenvNoCC.mkDerivation {
      pname = "noto-fonts-emoji";
      inherit version;

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-emoji";
        rev = "v${version}";
        sha256 = "1rgmcc6nqq805iqr8kvxxlk5cf50q714xaxk3ld6rjrd69kb8ix9";
      };

      depsBuildBuild = [
        buildPackages.stdenv.cc
        pkg-config
        cairo
      ];

      nativeBuildInputs = [
        imagemagick
        zopfli
        pngquant
        which
        emojiPythonEnv
      ];

      postPatch = ''
        patchShebangs *.py
        patchShebangs third_party/color_emoji/*.py
        # remove check for virtualenv, since we handle
        # python requirements using python.withPackages
        sed -i '/ifndef VIRTUAL_ENV/,+2d' Makefile

        # Make the build verbose so it won't get culled by Hydra thinking that
        # it somehow got stuck doing nothing.
        sed -i 's;\t@;\t;' Makefile
      '';

      enableParallelBuilding = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/noto
        cp NotoColorEmoji.ttf $out/share/fonts/noto
        runHook postInstall
      '';

      meta = with lib; {
        description = "Color and Black-and-White emoji fonts";
        homepage = "https://github.com/googlefonts/noto-emoji";
        license = with licenses; [ ofl asl20 ];
        platforms = platforms.all;
        maintainers = with maintainers; [ mathnerd314 sternenseemann ];
      };
    };

  noto-fonts-emoji-blob-bin =
    let
      pname = "noto-fonts-emoji-blob-bin";
      version = "14.0.1";
    in
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://github.com/C1710/blobmoji/releases/download/v${version}/Blobmoji.ttf";
        hash = "sha256-w9s7uF6E6nomdDmeKB4ATcGB/5A4sTwDvwHT3YGXz8g=";
      };

      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        install -Dm 444 $src $out/share/fonts/blobmoji/Blobmoji.ttf

        runHook postInstall
      '';

      meta = with lib; {
        description = "Noto Emoji with extended Blob support";
        homepage = "https://github.com/C1710/blobmoji";
        license = with licenses; [ ofl asl20 ];
        platforms = platforms.all;
        maintainers = with maintainers; [ rileyinman jk ];
      };
    };
}
