# Based upon https://src.fedoraproject.org/rpms/twitter-twemoji-fonts/tree/454acad50ba584d9602ccd4238fc5e585abc15c9
# The main difference is that we use “Twitter Color Emoji” name (which is recognized by upstream fontconfig)

{ stdenv
, fetchFromGitHub
, fetchpatch
, cairo
, graphicsmagick
, pkg-config
, pngquant
, python3
, which
, zopfli
, noto-fonts-emoji
}:

let
  version = "12.1.2";

  twemojiSrc = fetchFromGitHub {
    name = "twemoji";
    owner = "twitter";
    repo = "twemoji";
    rev = "v${version}";
    sha256 = "0vzmlp83vnk4njcfkn03jcc1vkg2rf12zf5kj3p3a373xr4ds1zn";
  };

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
    graphicsmagick
    pkg-config
    pngquant
    python3
    python3.pkgs.nototools
    which
    zopfli
  ];

  patches = [
    # ImageMagick -> GrahphicsMagick
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/twitter-twemoji-fonts/raw/3bc176c10ced2824fe03da5ff561e22a36bf8ccd/f/noto-emoji-use-gm.patch";
      sha256 = "0yfmfzaaiq5163c06172g4r734aysiqyv1s28siv642vqzsqh4i2";
    })
  ];

  postPatch = let
    templateSubstitutions = stdenv.lib.concatStringsSep "; " [
      ''s#Noto Color Emoji#Twitter Color Emoji#''
      ''s#NotoColorEmoji#TwitterColorEmoji#''
      ''s#Copyright .* Google Inc\.#Twitter, Inc and other contributors.#''
      ''s# Version .*# ${version}#''
      ''s#.*is a trademark.*##''
      ''s#Google, Inc\.#Twitter, Inc and other contributors#''
      ''s#http://www.google.com/get/noto/#https://twemoji.twitter.com/#''
      ''s#.*is licensed under.*#      Creative Commons Attribution 4.0 International#''
      ''s#http://scripts.sil.org/OFL#http://creativecommons.org/licenses/by/4.0/#''
    ];
  in ''
    patchShebangs ./flag_glyph_name.py

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
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm644 TwitterColorEmoji.ttf $out/share/fonts/truetype/TwitterColorEmoji.ttf
  '';

  meta = with stdenv.lib; {
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
    license = with licenses; [ asl20 ofl cc-by-40 mit ];
    maintainers = with maintainers; [ jtojnar ];
  };
}
