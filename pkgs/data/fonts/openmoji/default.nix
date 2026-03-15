{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nanoemoji,
  python3Packages,
  woff2,
  xmlstarlet,
  installFonts,
  # available color formats: ["cbdt" "glyf_colr_0" "glyf_colr_1" "sbix" "picosvgz" "untouchedsvgz"]
  # available black formats: ["glyf"]
  fontFormats ? [
    "glyf"
    "cbdt"
    "glyf_colr_0"
    "glyf_colr_1"
  ],
  # when at least one of the glyf_colr_0/1 formats is specified, whether to build maximum color fonts
  # "none" to not build any, "svg" to build colr+svg, "bitmap" to build cbdt+colr+svg fonts
  buildMaximumColorFonts ? "bitmap",
}:
let
  # all available methods
  methods = {
    black = [ "glyf" ];
    color = [
      "cbdt"
      "glyf_colr_0"
      "glyf_colr_1"
      "sbix"
      "picosvgz"
      "untouchedsvgz"
    ];
  };
in

assert lib.asserts.assertEachOneOf "fontFormats" fontFormats (methods.black ++ methods.color);
assert lib.asserts.assertOneOf "buildMaximumColorFonts" buildMaximumColorFonts [
  "none"
  "bitmap"
  "svg"
];

stdenvNoCC.mkDerivation rec {
  pname = "openmoji";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = "openmoji";
    rev = version;
    hash = "sha256-mE34l94C/jc7Fd4v7opMeneFZAou5w9KhjLSVxw0s/0=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  patches = [
    # fix paths and variables for nix build and skip generating font demos
    ./build.patch
  ];

  # nanoemoji depends on the python/ninja stub, whose setup hook would
  # otherwise replace installPhase with "ninja install"; this package has
  # no build.ninja at the source root, and its install is done entirely
  # by the installFonts preInstall hook.
  dontUseNinjaInstall = true;

  nativeBuildInputs = [
    nanoemoji
    python3Packages.fonttools
    woff2
    xmlstarlet
    installFonts
  ];

  methods_black = builtins.filter (m: builtins.elem m fontFormats) methods.black;
  methods_color = builtins.filter (m: builtins.elem m fontFormats) methods.color;
  saturations =
    lib.optional (methods_black != [ ]) "black" ++ lib.optional (methods_color != [ ]) "color";
  maximumColorVersions = lib.optionals (buildMaximumColorFonts != "none") (
    lib.optional (builtins.elem "glyf_colr_0" fontFormats) "0"
    ++ lib.optional (builtins.elem "glyf_colr_1" fontFormats) "1"
  );

  postPatch =
    lib.optionalString (buildMaximumColorFonts == "bitmap") ''
      substituteInPlace helpers/generate-fonts-runner.sh \
        --replace 'maximum_color' 'maximum_color --bitmaps'
    ''
    # remove the pre-built fonts shipped in the repo; this expression
    # rebuilds them from source, and stale copies of the same file names
    # would break the installFonts hook ("will not overwrite just-created")
    + ''
      rm -rf font
    '';

  buildPhase = ''
    runHook preBuild

    bash helpers/generate-fonts-runner.sh "$(pwd)/build" "${version}"

    # drop nanoemoji's raw intermediate fonts in build/{black,color}:
    # the installable, TTX-processed copies live in build/fonts, and the
    # intermediate ones would collide with them in the installFonts hook
    rm -rf build/black build/color

    runHook postBuild
  '';

  meta = {
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [
      _999eagle
      fgaz
    ];
    platforms = lib.platforms.all;
    homepage = "https://openmoji.org/";
    downloadPage = "https://github.com/hfg-gmuend/openmoji/releases";
    description = "Open-source emojis for designers, developers and everyone else";
  };
}
