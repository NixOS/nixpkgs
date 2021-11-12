{ lib
, stdenv
, fetchFromGitHub
, scfbuild
, nodejs
, nodePackages
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
    nodejs
    nodePackages.glob
    nodePackages.lodash
  ];

  buildPhase = ''
    runHook preBuild

    node helpers/generate-font-glyphs.js

    cd font
    scfbuild -c scfbuild-${variant}.yml

    runHook postBuild
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
