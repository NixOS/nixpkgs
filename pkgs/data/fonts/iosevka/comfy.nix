{
  lib,
  iosevka,
  fetchFromGitHub,
  buildNpmPackage,
}:

let
  sets = [
    # Family                  | Shapes | Spacing | Style      | Ligatures |
    # ------------------------+--------+---------+------------+-----------|
    "comfy" # | Sans   | Compact | Monospaced | Yes       |
    "comfy-fixed" # | Sans   | Compact | Monospaced | No        |
    "comfy-duo" # | Sans   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-motion" # | Slab   | Compact | Monospaced | Yes       |
    "comfy-motion-fixed" # | Slab   | Compact | Monospaced | No        |
    "comfy-motion-duo" # | Slab   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide" # | Sans   | Wide    | Monospaced | Yes       |
    "comfy-wide-fixed" # | Sans   | Wide    | Monospaced | No        |
    "comfy-wide-duo" # | Sans   | Wide    | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide-motion" # | Slab   | Wide    | Monospaced | Yes       |
    "comfy-wide-motion-fixed" # Slab   | Wide    | Monospaced | No        |
    "comfy-wide-motion-duo" # | Slab   | Wide    | Duospaced  | Yes       |
  ];
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "sha256-z9OlxeD88HuPJF88CsAy3vd1SFpJF1qh5c/0AIeMA7o=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  makeIosevkaFont =
    set:
    let
      superBuildNpmPackage = buildNpmPackage;
    in
    (iosevka.override {
      inherit set privateBuildPlan;
      buildNpmPackage =
        args:
        superBuildNpmPackage (
          args
          // {
            pname = "iosevka-${set}";
            inherit version;

            src = fetchFromGitHub {
              owner = "be5invis";
              repo = "iosevka";
              rev = "v31.9.1";
              hash = "sha256-eAC4afBfHfiteYCzBNGFG2U/oCA7C5CdUlQVSO9Dg6E=";
            };

            npmDepsHash = "sha256-xwGR21+CpZRFdZYz8SQrSf1tkp3fjGudoMmP5TGgEe8=";

            meta = with lib; {
              inherit (src.meta) homepage;
              description = ''
                Customised build of the Iosevka typeface, with a consistent
                rounded style and overrides for almost all individual glyphs
                in both roman (upright) and italic (slanted) variants.
              '';
              license = licenses.ofl;
              platforms = iosevka.meta.platforms;
              maintainers = [ maintainers.DamienCassou ];
            };
          }
        );
    });
in
builtins.listToAttrs (
  map (set: {
    name = set;
    value = makeIosevkaFont set;
  }) sets
)
