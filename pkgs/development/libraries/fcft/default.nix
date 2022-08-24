{ stdenv, lib, fetchFromGitea, pkg-config, meson, ninja, scdoc
, freetype, fontconfig, pixman, tllist, check
# Text shaping methods to enable, empty list disables all text shaping.
# See `availableShapingTypes` or upstream meson_options.txt for available types.
, withShapingTypes ? [ "grapheme" "run" ]
, harfbuzz, utf8proc
, fcft # for passthru.tests
}:

let
  # Needs to be reflect upstream meson_options.txt
  availableShapingTypes = [
    "grapheme"
    "run"
  ];

  # Courtesy of sternenseemann and FRidh, commit c9a7fdfcfb420be8e0179214d0d91a34f5974c54
  mesonFeatureFlag = opt: b: "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "3.1.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fcft";
    rev = version;
    sha256 = "sha256-HDXq9/otJc64AHRNERyzLyurMH89ijT1NRPjp1+T0GY=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist ]
    ++ lib.optionals (withShapingTypes != []) [ harfbuzz ]
    ++ lib.optionals (builtins.elem "run" withShapingTypes) [ utf8proc ];
  checkInputs = [ check ];

  mesonBuildType = "release";
  mesonFlags = builtins.map (t:
    mesonFeatureFlag "${t}-shaping" (lib.elem t withShapingTypes)
  ) availableShapingTypes;

  doCheck = true;

  outputs = [ "out" "doc" "man" ];

  passthru.tests = {
    noShaping = fcft.override { withShapingTypes = []; };
    onlyGraphemeShaping = fcft.override { withShapingTypes = [ "grapheme" ]; };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    changelog = "https://codeberg.org/dnkl/fcft/releases/tag/${version}";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [
      fionera
      sternenseemann
    ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
