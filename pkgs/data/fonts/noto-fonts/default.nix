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
, fontconfig
, python3
}:

let
  noto-pkg =
    stdenvNoCC.mkDerivation {
      pname = "noto-fonts";
      version = "unstable-2022-04-25";

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-fonts";
        rev = "a19de47f845dbd4c61b884c7ff90ce993555d05d";
        sparseCheckout = ''
          unhinted/otf
          unhinted/variable-ttf
        '';
        hash = "sha256-7Jzo7402CiOcn2q++zbAzn2tP/y2x7QJuwjcP1NoyLQ=";
      };

      analyzeScan = ./analyze_scan.py;

      nativeBuildInputs = [ buildPackages.fontconfig.bin buildPackages.python3 ];

      outputs = [ "out" "extra" "croscore" ];

      installPhase = ''
        fc-scan ./unhinted -f '"%{fullname[0]}","%{file}"\n' > scan.csv
        python $analyzeScan
        local out_ttf=$out/share/fonts/google-noto
        while read p; do
          install -m444 -Dt $out_ttf "$p"
        done <noto_fonts_list.txt
        local extra_ttf=$extra/share/fonts/google-noto
        while read p; do
          install -m444 -Dt $extra_ttf "$p"
        done <noto_extra_list.txt
        local croscore_ttf=$croscore/share/fonts/google-croscore
        install -m444 -Dt $croscore_ttf ./unhinted/otf/Arimo/*
        install -m444 -Dt $croscore_ttf ./unhinted/otf/Cousine/*
        install -m444 -Dt $croscore_ttf ./unhinted/otf/Tinos/*
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

          noto-fonts contains Regular, Bold, and Light weights and Italic style,
          and noto-fonts-extra contains the rest.

          This package also outputs croscore-fonts which includes the Arimo, Cousine, and Tinos fonts.
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ mathnerd314 emily ];
      };

      passthru.tests.noto-fonts = nixosTests.noto-fonts;

    };

  mkNotoCJK = { typeface, version, rev, sha256 }:
    stdenvNoCC.mkDerivation {
      pname = "noto-fonts-cjk-${lib.toLower typeface}";
      inherit version;

      src = fetchFromGitHub {
        owner = "googlefonts";
        repo = "noto-cjk";
        inherit rev sha256;
        sparseCheckout = "${typeface}/Variable/OTC";
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
in

{
  noto-fonts = noto-pkg.out;
  noto-fonts-extra = noto-pkg.extra;
  croscore-fonts = noto-pkg.croscore;
  # TODO for croscore: use more recent VF versions from
  # https://github.com/googlefonts/Arimo and similar repos

  noto-fonts-cjk-sans = mkNotoCJK {
    typeface = "Sans";
    version = "2.004";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-11d/78i21yuzxrfB5t2VQN9OBz/qZKeozuS6BrLFjzw=";
  };

  noto-fonts-cjk-serif = mkNotoCJK {
    typeface = "Serif";
    version = "2.000";
    rev = "9f7f3c38eab63e1d1fddd8d50937fe4f1eacdb1d";
    sha256 = "sha256-G+yl3LZvSFpbEUuuvattPDctKTzBCshOi970DcbPliE=";
  };

  noto-fonts-emoji = let
    version = "2.034";
    emojiPythonEnv =
      buildPackages.python3.withPackages (p: with p; [ fonttools nototools ]);
  in stdenvNoCC.mkDerivation {
    pname = "noto-fonts-emoji";
    inherit version;

    src = fetchFromGitHub {
      owner = "googlefonts";
      repo = "noto-emoji";
      rev = "v${version}";
      sha256 = "1d6zzk0ii43iqfnjbldwp8sasyx99lbjp1nfgqjla7ixld6yp98l";
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

    passthru.tests.noto-fonts = nixosTests.noto-fonts;
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
