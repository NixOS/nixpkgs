{ lib
, stdenv
, fetchFromGitHub
, scfbuild
, python3Packages
, variant ? "color" # "color" or "black"
}:

let
  filename = builtins.replaceStrings
    [ "color"              "black"              ]
    [ "OpenMoji-Color.ttf" "OpenMoji-Black.ttf" ]
    variant;

in stdenv.mkDerivation rec {
  pname = "openmoji";
  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = pname;
    rev = version;
    sha256 = "sha256-7G6a+LFq79njyPhnDhhSJ98Smw5fWlfcsFj6nWBPsSk=";
  };

  nativeBuildInputs = [
    scfbuild
  ];

  buildPhase = ''
    # Bash reimplementation of helpers/export-svg-font.js
    # so we don't need to build all the node deps first
    hexcodes=()
    missingGlyphBlack='./black/svg/25A1.svg'
    missingGlyphColor='./color/svg/25A1.svg'
    for f in ./color/svg/*.svg; do
      basename=$(basename "$f" .svg)
      hexcodes+=(''${basename//-/ })
      filename=$(basename "$f");
      cp "./color/svg/$filename" "./font/tmp-color/$filename"
      cp "./black/svg/$filename" "./font/tmp-black/$filename"
    done

    hexcodes=($(uniq<<<"''${hexcodes[@]}"))

    for h in ''${hexcodes[@]}; do
      filename="$h.svg"
      if [ ! -e "./color/svg/$filename" ]; then
        echo "$h is missing -> substitute with \"Missing Glyph\": $filename"
        cp $missingGlyphColor "./font/tmp-color/$filename"
        cp $missingGlyphBlack "./font/tmp-black/$filename"
      fi
    done

    # Actually build the font:
    cd font
    scfbuild -c scfbuild-${variant}.yml
  '';

  installPhase = ''
    install -Dm644 ${filename} $out/share/fonts/truetype/${filename}
  '';

  meta = with lib; {
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    homepage = "https://openmoji.org/";
    downloadPage = "https://github.com/hfg-gmuend/openmoji/releases";
    description = "Open-source emojis for designers, developers and everyone else";
  };
}
