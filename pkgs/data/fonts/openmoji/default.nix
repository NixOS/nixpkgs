{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nanoemoji,
  python3Packages,
  woff2,
  xmlstarlet,
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
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = "openmoji";
    rev = version;
    hash = "sha256-4dYtLaABu88z25Ud/cuOECajxSJWR01qcTIZNWN7Fhw=";
  };

  patches = [
    # fix paths and variables for nix build and skip generating font demos
    ./build.patch
  ];

  nativeBuildInputs = [
    nanoemoji
    python3Packages.fonttools
    woff2
    xmlstarlet
  ];

  methods_black = builtins.filter (m: builtins.elem m fontFormats) methods.black;
  methods_color = builtins.filter (m: builtins.elem m fontFormats) methods.color;
  saturations =
    lib.optional (methods_black != [ ]) "black" ++ lib.optional (methods_color != [ ]) "color";
  maximumColorVersions = lib.optionals (buildMaximumColorFonts != "none") (
    lib.optional (builtins.elem "glyf_colr_0" fontFormats) "0"
    ++ lib.optional (builtins.elem "glyf_colr_1" fontFormats) "1"
  );

  postPatch = lib.optionalString (buildMaximumColorFonts == "bitmap") ''
    substituteInPlace helpers/generate-fonts-runner.sh \
      --replace 'maximum_color' 'maximum_color --bitmaps'
  '';

  buildPhase = ''
    runHook preBuild

    bash helpers/generate-fonts-runner.sh "$(pwd)/build" "${version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype $out/share/fonts/woff2
    cp build/fonts/*/*.ttf $out/share/fonts/truetype/
    cp build/fonts/*/*.woff2 $out/share/fonts/woff2/

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [
      _999eagle
      fgaz
    ];
    platforms = platforms.all;
    homepage = "https://openmoji.org/";
    downloadPage = "https://github.com/hfg-gmuend/openmoji/releases";
    description = "Open-source emojis for designers, developers and everyone else";
  };
}
