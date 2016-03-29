{ stdenv, fetchurl, fetchFromGitHub, optipng, cairo, unzip, fontforge, pythonPackages, pkgconfig }:
rec {
  # 18MB
  noto-fonts = let version = "git-2016-03-29"; in stdenv.mkDerivation {
    name = "noto-fonts-${version}";

    src = fetchFromGitHub {
      owner = "googlei18n";
      repo = "noto-fonts";
      rev = "e8b0af48b15d64bd490edab4418b5e396cf29644";
      sha256 = "02yv12fbb4n1gp9g9m0qxnj6adpg9hfsr9377h2d4xsf6sxcgy6f";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/fonts/noto
      cp hinted/*.ttf $out/share/fonts/noto
      # Also copy unhinted & alpha fonts for better glyph coverage,
      # if they don't have a hinted version
      # (see https://groups.google.com/d/msg/noto-font/ZJSkZta4n5Y/tZBnLcPdbS0J)
      cp -n unhinted/*.ttf $out/share/fonts/noto
      cp -n alpha/*.ttf $out/share/fonts/noto
    '';

    preferLocalBuild = true;

    meta = with stdenv.lib; {
      inherit version;
      description = "Beautiful and free fonts for many languages";
      homepage = https://www.google.com/get/noto/;
      longDescription =
      ''
        When text is rendered by a computer, sometimes characters are displayed as
        “tofu”. They are little boxes to indicate your device doesn’t have a font to
        display the text.

        Google has been developing a font family called Noto, which aims to support all
        languages with a harmonious look and feel. Noto is Google’s answer to tofu. The
        name noto is to convey the idea that Google’s goal is to see “no more tofu”.
        Noto has multiple styles and weights, and freely available to all.

        This package also includes the Arimo, Cousine, and Tinos fonts.
      '';
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ mathnerd314 ];
    };
  };
  # 89MB
  noto-fonts-cjk = let version = "1.004"; in stdenv.mkDerivation {
    name = "noto-fonts-cjk-${version}";

    src = fetchurl {
      # Same as https://noto-website.storage.googleapis.com/pkgs/NotoSansCJK.ttc.zip but versioned & with no extra SIL license file
      url = "https://raw.githubusercontent.com/googlei18n/noto-cjk/40d9f5b179a59a06b98373c76bdc3e2119e4e6b2/NotoSansCJK.ttc.zip";
      sha256 = "1vg3si6slvk8cklq6s5c76s84kqjc4wvwzr4ysljzjpgzra2rfn6";
    };

    buildInputs = [ unzip ];

    phases = "unpackPhase installPhase";

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/share/fonts/noto
      cp *.ttc $out/share/fonts/noto
    '';

    preferLocalBuild = true;

    meta = with stdenv.lib; {
      inherit version;
      description = "Beautiful and free fonts for CJK languages";
      homepage = https://www.google.com/get/noto/help/cjk/;
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
      maintainers = with maintainers; [ mathnerd314 ];
    };
  };
  # 12MB
  noto-fonts-emoji = let version = "git-2015-08-17"; in stdenv.mkDerivation {
    name = "noto-fonts-emoji-${version}";

    src = fetchFromGitHub {
      owner = "googlei18n";
      repo = "noto-emoji";
      rev = "ffd7cfd0c84b7bf37210d0908ac94adfe3259ff2";
      sha256 = "1pa94gw2y0b6p8r81zbjzcjgi5nrx4dqrqr6mk98wj6jbi465sh2";
    };

    buildInputs = with pythonPackages; [
      optipng cairo fontforge python nototools fonttools pkgconfig
    ];

    #FIXME: perhaps use our pngquant instead
    preConfigure = ''
      for f in ./*.py ./third_party/pngquant/configure; do
        patchShebangs "$f"
      done
    '';

    preBuild = ''
      export PYTHONPATH=$PYTHONPATH:$PWD
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/noto
      cp NotoColorEmoji.ttf NotoEmoji-Regular.ttf $out/share/fonts/noto
    '';

    meta = with stdenv.lib; {
      inherit version;
      description = "Color and Black-and-White emoji fonts";
      homepage = https://github.com/googlei18n/noto-emoji;
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ mathnerd314 ];
    };
  };
}
