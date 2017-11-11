{ stdenv, fetchzip, fetchFromGitHub, optipng, cairo, unzip, pythonPackages, pkgconfig, pngquant, which, imagemagick }:

rec {
  # 18MB
  noto-fonts = let version = "2017-10-24-phase3-second-cleanup"; in fetchzip {
    name = "noto-fonts-${version}";

    url = "https://github.com/googlei18n/noto-fonts/archive/v${version}.zip";
    postFetch = ''
      unzip $downloadedFile

      mkdir -p $out/share/fonts/noto
      cp noto-fonts-*/hinted/*.ttf $out/share/fonts/noto
      # Also copy unhinted & alpha fonts for better glyph coverage,
      # if they don't have a hinted version
      # (see https://groups.google.com/d/msg/noto-font/ZJSkZta4n5Y/tZBnLcPdbS0J)
      cp -n noto-fonts-*/unhinted/*.ttf $out/share/fonts/noto
      cp -n noto-fonts-*/alpha/*.ttf $out/share/fonts/noto
    '';
    sha256 = "013l816cq9svdji266sccscm9sf9pfn472gq9lnqkzlwaxx9qrrl";

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
  noto-fonts-cjk = let version = "1.004"; in fetchzip {
    name = "noto-fonts-cjk-${version}";

    # Same as https://noto-website.storage.googleapis.com/pkgs/NotoSansCJK.ttc.zip but versioned & with no extra SIL license file
    url = "https://raw.githubusercontent.com/googlei18n/noto-cjk/40d9f5b179a59a06b98373c76bdc3e2119e4e6b2/NotoSansCJK.ttc.zip";
    postFetch = ''
      mkdir -p $out/share/fonts
      unzip -j $downloadedFile \*.ttc -d $out/share/fonts/noto
    '';
    sha256 = "0ghw2azqq3nkcxsbvf53qjmrhcfsnry79rq7jsr0wwi2pn7d3dsq";

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
  noto-fonts-emoji = let version = "2017-09-13-design-refresh"; in stdenv.mkDerivation {
    name = "noto-fonts-emoji-${version}";

    src = fetchFromGitHub {
      owner = "googlei18n";
      repo = "noto-emoji";
      rev = "v${version}";
      sha256 = "1ixz03207kzh6jhmw8bpi77pxkfzq46dk26sr41m5kkvc14d14vl";
    };

    buildInputs = [ cairo ];
    nativeBuildInputs = [ pngquant optipng which cairo pkgconfig imagemagick ]
                     ++ (with pythonPackages; [ python fonttools nototools ]);

    postPatch = ''
      sed -i 's,^PNGQUANT :=.*,PNGQUANT := ${pngquant}/bin/pngquant,' Makefile
      patchShebangs flag_glyph_name.py
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/share/fonts/noto
      cp NotoColorEmoji.ttf fonts/NotoEmoji-Regular.ttf $out/share/fonts/noto
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
