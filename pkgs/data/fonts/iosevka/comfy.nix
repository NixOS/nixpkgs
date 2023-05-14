{ lib, iosevka, fetchFromSourcehut, fetchFromGitHub, buildNpmPackage }:

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
  version = "1.2.0";
  src = fetchFromSourcehut {
    owner = "~protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "sha256-gHDERf3eDsb59wz+kGa2wLY7RDRWs2woi5P2rZDYjL0=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  makeIosevkaFont = set:
    let superBuildNpmPackage = buildNpmPackage; in
    (iosevka.override rec {
      inherit set privateBuildPlan;
      buildNpmPackage = args: superBuildNpmPackage
        (args // {
          inherit version;

          src = fetchFromGitHub {
            owner = "be5invis";
            repo = "iosevka";
            rev = "d3b461432137b36922e41322c2e45a2401e727a5";
            hash = "sha256-Sm+eG6ovVLmvKvQFEZblQV3jCLQRrc9Gga3pukwteLE=";
          };

          npmDepsHash = "sha256-pikpi9eyo1a+AFLr7BMl1kegy3PgYFjzmE3QJqPXpNM=";

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
