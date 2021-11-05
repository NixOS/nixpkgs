{ stdenv
, stdenvNoCC
, lib
, fetchFromGitHub
, fetchurl
, fetchzip
, cairo
, python3
, pkg-config
, pngquant
, which
, imagemagick
, zopfli
}:

let
  mkNoto = { pname, weights }:
    stdenvNoCC.mkDerivation {
      inherit pname;
      version = "2020-01-23";

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-fonts";
        rev = "f4726a2ec36169abd02a6d8abe67c8ff0236f6d8";
        sha256 = "0zc1r7zph62qmvzxqfflsprazjf6x1qnwc2ma27kyzh6v36gaykw";
      };

      installPhase = ''
        # We copy in reverse preference order -- unhinted first, then
        # hinted -- to get the "best" version of each font while
        # maintaining maximum coverage.
        #
        # TODO: install OpenType, variable versions?
        local out_ttf=$out/share/fonts/truetype/noto
        install -m444 -Dt $out_ttf phaseIII_only/unhinted/ttf/*/*-${weights}.ttf
        install -m444 -Dt $out_ttf phaseIII_only/hinted/ttf/*/*-${weights}.ttf
        install -m444 -Dt $out_ttf unhinted/*/*-${weights}.ttf
        install -m444 -Dt $out_ttf hinted/*/*-${weights}.ttf
      '';

      meta = with lib; {
        description = "Beautiful and free fonts for many languages";
        homepage = "https://www.google.com/get/noto/";
        longDescription =
        ''
          When text is rendered by a computer, sometimes characters are
          displayed as “tofu”. They are little boxes to indicate your device
          doesn’t have a font to display the text.

          Google has been developing a font family called Noto, which aims to
          support all languages with a harmonious look and feel. Noto is
          Google’s answer to tofu. The name noto is to convey the idea that
          Google’s goal is to see “no more tofu”.  Noto has multiple styles and
          weights, and freely available to all.

          This package also includes the Arimo, Cousine, and Tinos fonts.
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ mathnerd314 emily ];
      };
    };
in

{
  noto-fonts = mkNoto {
    pname = "noto-fonts";
    weights = "{Regular,Bold,Light,Italic,BoldItalic,LightItalic}";
  };

  noto-fonts-extra = mkNoto {
    pname = "noto-fonts-extra";
    weights = "{Black,Condensed,Extra,Medium,Semi,Thin}*";
  };

  noto-fonts-cjk = let zip = fetchzip {
    url = let rev = "be6c059ac1587e556e2412b27f5155c8eb3ddbe6"; in
      "https://raw.githubusercontent.com/googlefonts/noto-cjk/${rev}/NotoSansCJK.ttc.zip";
    # __MACOSX...
    stripRoot = false;
    sha256 = "0ik4z2b15i0pghskgfm3adzb0h35fr4gyzvz3bq49hhkhn9h85vi";
  }; in stdenvNoCC.mkDerivation {
    pname = "noto-fonts-cjk";
    version = "2.001";

    buildCommand = ''
      install -m444 -Dt $out/share/fonts/opentype/noto-cjk ${zip}/*.ttc
    '';

    meta = with lib; {
      description = "Beautiful and free fonts for CJK languages";
      homepage = "https://www.google.com/get/noto/help/cjk/";
      longDescription =
      ''
        Noto Sans CJK is a sans serif typeface designed as an intermediate style
        between the modern and traditional. It is intended to be a multi-purpose
        digital font for user interface designs, digital content, reading on laptops,
        mobile devices, and electronic books. Noto Sans CJK comprehensively covers
        Simplified Chinese, Traditional Chinese, Japanese, and Korean in a unified font
        family. It supports regional variants of ideographic characters for each of the
        four languages. In addition, it supports Japanese kana, vertical forms, and
        variant characters (itaiji); it supports Korean hangeul — both contemporary and
        archaic.
      '';
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [ mathnerd314 emily ];
    };
  };

  noto-fonts-emoji = let
    version = "2.034";
    emojiPythonEnv =
      python3.withPackages (p: with p; [ fonttools nototools ]);
  in stdenv.mkDerivation {
    pname = "noto-fonts-emoji";
    inherit version;

    src = fetchFromGitHub {
      owner = "googlefonts";
      repo = "noto-emoji";
      rev = "v${version}";
      sha256 = "1d6zzk0ii43iqfnjbldwp8sasyx99lbjp1nfgqjla7ixld6yp98l";
    };

    makeFlags = [
      # TODO(@sternenseemann): remove if afdko is new enough to know about Unicode 14.0
      "BYPASS_SEQUENCE_CHECK=True"
    ];

    nativeBuildInputs = [
      cairo
      imagemagick
      zopfli
      pngquant
      which
      pkg-config
      emojiPythonEnv
    ];

    postPatch = ''
      patchShebangs *.py
      patchShebangs third_party/color_emoji/*.py
      # remove check for virtualenv, since we handle
      # python requirements using python.withPackages
      sed -i '/ifndef VIRTUAL_ENV/,+2d' Makefile

      # Remove check for missing zopfli, it doesn't
      # work and we guarantee its presence already.
      sed -i '/ifdef MISSING_ZOPFLI/,+2d' Makefile
      sed -i '/ifeq (,$(shell which $(ZOPFLIPNG)))/,+4d' Makefile

      sed -i '/ZOPFLIPNG = zopflipng/d' Makefile
      echo "ZOPFLIPNG = ${zopfli}/bin/zopflipng" >> Makefile

      # Make the build verbose so it won't get culled by Hydra thinking that
      # it somehow got stuck doing nothing.
      sed -i 's;\t@;\t;' Makefile
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/share/fonts/noto
      cp NotoColorEmoji.ttf fonts/NotoEmoji-Regular.ttf $out/share/fonts/noto
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
    fetchurl {
      name = "${pname}-${version}";
      url = "https://github.com/C1710/blobmoji/releases/download/v${version}/Blobmoji.ttf";
      sha256 = "sha256-wSH9kRJ8y2i5ZDqzeT96dJcEJnHDSpU8bOhmxaT+UCg=";

      downloadToTemp = true;
      recursiveHash = true;
      postFetch = ''
        install -Dm 444 $downloadedFile $out/share/fonts/blobmoji/Blobmoji.ttf
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
