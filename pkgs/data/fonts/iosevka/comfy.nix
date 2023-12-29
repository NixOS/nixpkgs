{ lib, iosevka, fetchFromGitHub, buildNpmPackage }:

let
  sets = [
    # Family                  | Shapes | Spacing | Style      | Ligatures |
    # ------------------------+--------+---------+------------+-----------|
    "comfy"                   # Sans   | Compact | Monospaced | Yes       |
    "comfy-fixed"             # Sans   | Compact | Monospaced | No        |
    "comfy-duo"               # Sans   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-motion"            # Slab   | Compact | Monospaced | Yes       |
    "comfy-motion-fixed"      # Slab   | Compact | Monospaced | No        |
    "comfy-motion-duo"        # Slab   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide"              # Sans   | Wide    | Monospaced | Yes       |
    "comfy-wide-fixed"        # Sans   | Wide    | Monospaced | No        |
    "comfy-wide-duo"          # Sans   | Wide    | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide-motion"       # Slab   | Wide    | Monospaced | Yes       |
    "comfy-wide-motion-fixed" # Slab   | Wide    | Monospaced | No        |
    "comfy-wide-motion-duo"   # Slab   | Wide    | Duospaced  | Yes       |
  ];
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "sha256-kfEEJ6F1/dsG9CSLWcr0QOOnQxHPgPgb4QhgFrHTklE=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  makeIosevkaFont = set:
    let superBuildNpmPackage = buildNpmPackage; in
    (iosevka.override {
      inherit set privateBuildPlan;
      buildNpmPackage = args: superBuildNpmPackage
        (args // {
          inherit version;

          src = fetchFromGitHub {
            owner = "be5invis";
            repo = "iosevka";
            rev = "f6e57fbf0b1242ad3069d45c815d79b9d68871a2";
            hash = "sha256-cS3SCKzUjVXF+n0Rt5eBLzieATB7W+hwEbzh6OQrMo4=";
          };

          npmDepsHash = "sha256-c+ltdh5e3+idclYfqp0Xh9IUwoj7XYP1uzJG6+a5gFU=";

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
        });
    });
in
builtins.listToAttrs (builtins.map
  (set: {
    name = set;
    value = makeIosevkaFont set;
  })
  sets)
