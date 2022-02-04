{ stdenv
, stdenvNoCC
, lib
, fetchFromGitHub
, fetchurl
, cairo
, nixosTests
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

  mkNotoCJK = { typeface, version, rev, sha256 }:
    stdenvNoCC.mkDerivation {
      pname = "noto-fonts-cjk-${lib.toLower typeface}";
      inherit version;

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-cjk";
        inherit rev sha256;
        sparseCheckout = "${typeface}/OTC";
      };

      installPhase = ''
        install -m444 -Dt $out/share/fonts/opentype/noto-cjk ${typeface}/OTC/*.ttc
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

  noto-fonts-cjk-sans = mkNotoCJK {
    typeface = "Sans";
    version = "2.004";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-pNC/WJCYHSlU28E/CSFsrEMbyCe/6tjevDlOvDK9RwU=";
  };

  noto-fonts-cjk-serif = mkNotoCJK {
    typeface = "Serif";
    version = "2.000";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-Iy4lmWj5l+/Us/dJJ/Jl4MEojE9mrFnhNQxX2zhVngY=";
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
