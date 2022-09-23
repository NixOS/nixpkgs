# Based upon https://src.fedoraproject.org/rpms/twitter-twemoji-fonts
# The main difference is that we use “Twitter Color Emoji” name (which is recognized by upstream fontconfig)

{ lib, stdenv
, fetchFromGitHub
, cairo
, imagemagick
, pkg-config
, pngquant
, python3
, which
, zopfli
, noto-fonts-emoji
}:

let
  version = "14.0.0";

  twemojiSrc = fetchFromGitHub {
    name = "twemoji";
    owner = "twitter";
    repo = "twemoji";
    rev = "v${version}";
    sha256 = "sha256-ar6rBYudMIMngMVe/IowDV3X8wA77JBA6g0x/M7YLMg=";
  };

  pythonEnv =
    python3.withPackages (ps: with ps; [ fonttools nototools ]);

in
stdenv.mkDerivation rec {
  pname = "twitter-color-emoji";
  inherit version;

  srcs = [
    noto-fonts-emoji.src
    twemojiSrc
  ];

  sourceRoot = noto-fonts-emoji.src.name;

  postUnpack = ''
    chmod -R +w ${twemojiSrc.name}
    mv ${twemojiSrc.name} ${noto-fonts-emoji.src.name}
  '';

  nativeBuildInputs = [
    cairo
    imagemagick
    pkg-config
    pngquant
    pythonEnv
    which
    zopfli
  ];

  postPatch = let
    templateSubstitutions = lib.concatStringsSep "; " [
      "s#Noto Color Emoji#Twitter Color Emoji#"
      "s#NotoColorEmoji#TwitterColorEmoji#"
      ''s#Copyright .* Google Inc\.#Twitter, Inc and other contributors.#''
      "s# Version .*# ${version}#"
      "s#.*is a trademark.*##"
      ''s#Google, Inc\.#Twitter, Inc and other contributors#''
      "s#http://www.google.com/get/noto/#https://twemoji.twitter.com/#"
      "s#.*is licensed under.*#      Creative Commons Attribution 4.0 International#"
      "s#http://scripts.sil.org/OFL#http://creativecommons.org/licenses/by/4.0/#"
    ];
  in ''
    ${noto-fonts-emoji.postPatch}

    sed '${templateSubstitutions}' NotoColorEmoji.tmpl.ttx.tmpl > TwitterColorEmoji.tmpl.ttx.tmpl
    pushd ${twemojiSrc.name}/assets/72x72/
    for png in *.png; do
        mv $png emoji_u''${png//-/_}
    done
    popd
  '';

  makeFlags = [
    "EMOJI=TwitterColorEmoji"
    "EMOJI_SRC_DIR=${twemojiSrc.name}/assets/72x72"
    "BODY_DIMENSIONS=76x72"
    # twemoji contains some codepoints noto doesn't like
    "BYPASS_SEQUENCE_CHECK=True"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm644 TwitterColorEmoji.ttf $out/share/fonts/truetype/TwitterColorEmoji.ttf
  '';

  meta = with lib; {
    description = "Color emoji font with a flat visual style, designed and used by Twitter";
    longDescription = ''
      A bitmap color emoji font built from the Twitter Emoji for
      Everyone artwork with support for ZWJ, skin tone diversity and country
      flags.

      This font uses Google’s CBDT format making it work on Android and Linux graphical stack.
    '';
    homepage = "https://twemoji.twitter.com/";
    # In noto-emoji-fonts source
    ## noto-emoji code is in ASL 2.0 license
    ## Emoji fonts are under OFL license
    ### third_party color-emoji code is in ASL 2.0 license
    ### third_party region-flags code is in Public Domain license
    # In twemoji source
    ## Artwork is Creative Commons Attribution 4.0 International
    ## Non-artwork is MIT
    # In Fedora twitter-twemoji-fonts source
    ## spec files are MIT: https://fedoraproject.org/wiki/Licensing:Main#License_of_Fedora_SPEC_Files
    license = with licenses; [ asl20 ofl cc-by-40 mit ];
    maintainers = with maintainers; [ jtojnar emily ];
  };
}
