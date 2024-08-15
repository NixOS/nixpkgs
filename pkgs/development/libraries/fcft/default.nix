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
in

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "3.1.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fcft";
    rev = version;
    hash = "sha256-Wgm2QdW4rg573soF/8HhDmlyN4S2cA0VWOejow464gU=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist ]
    ++ lib.optionals (withShapingTypes != []) [ harfbuzz ]
    ++ lib.optionals (builtins.elem "run" withShapingTypes) [ utf8proc ];
  nativeCheckInputs = [ check ];

  mesonBuildType = "release";
  mesonFlags = builtins.map (t:
    lib.mesonEnable "${t}-shaping" (lib.elem t withShapingTypes)
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
    license = with licenses; [ mit zlib ];
    platforms = with platforms; linux;
  };
}
