{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, scfbuild
, fontforge
, libuninameslist
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

  # With newer fontforge the build hangs, see
  # https://github.com/NixOS/nixpkgs/issues/167869
  # Patches etc taken from
  # https://github.com/NixOS/nixpkgs/commit/69da642a5a9bb433138ba1b13c8d56fb5bb6ec05
  fontforge-20201107 = fontforge.overrideAttrs (old: rec {
    version = "20201107";
    src = fetchFromGitHub {
      owner = "fontforge";
      repo = "fontforge";
      rev = version;
      sha256 = "sha256-Rl/5lbXaPgIndANaD0IakaDus6T53FjiBb45FIuGrvc=";
    };
    patches = [
      (fetchpatch {
        url = "https://salsa.debian.org/fonts-team/fontforge/raw/76bffe6ccf8ab20a0c81476a80a87ad245e2fd1c/debian/patches/0001-add-extra-cmake-install-rules.patch";
        sha256 = "u3D9od2xLECNEHhZ+8dkuv9818tPkdP6y/Tvd9CADJg=";
      })
      (fetchpatch {
        url = "https://github.com/fontforge/fontforge/commit/69e263b2aff29ad22f97f13935cfa97a1eabf207.patch";
        sha256 = "06yyf90605aq6ppfiz83mqkdmnaq5418axp9jgsjyjq78b00xb29";
      })
    ];
    buildInputs = old.buildInputs ++ [ libuninameslist ];
  });
  scfbuild-with-fontforge-20201107 = scfbuild.override (old: {
    fontforge = fontforge-20201107;
  });

in stdenv.mkDerivation rec {
  pname = "openmoji";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = pname;
    rev = version;
    sha256 = "sha256-XnSRSlWXOMeSaO6dKaOloRg3+sWS4BSaro4bPqOyKmE=";
  };

  nativeBuildInputs = [
    scfbuild-with-fontforge-20201107
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
