{ lib, iosevka, fetchFromGitHub, buildNpmPackage }:

let
  sets = [
    # Family                  | Shapes | Spacing | Style      | Ligatures |
    # ------------------------+--------+---------+------------+-----------|
    "comfy" #                 | Sans   | Compact | Monospaced | Yes       |
    "comfy-fixed" #           | Sans   | Compact | Monospaced | No        |
    "comfy-duo" #             | Sans   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-motion" #          | Slab   | Compact | Monospaced | Yes       |
    "comfy-motion-fixed" #    | Slab   | Compact | Monospaced | No        |
    "comfy-motion-duo" #      | Slab   | Compact | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide" #            | Sans   | Wide    | Monospaced | Yes       |
    "comfy-wide-fixed" #      | Sans   | Wide    | Monospaced | No        |
    "comfy-wide-duo" #        | Sans   | Wide    | Duospaced  | Yes       |
    # ------------------------+--------+---------+------------+-----------|
    "comfy-wide-motion" #     | Slab   | Wide    | Monospaced | Yes       |
    "comfy-wide-motion-fixed" # Slab   | Wide    | Monospaced | No        |
    "comfy-wide-motion-duo" # | Slab   | Wide    | Duospaced  | Yes       |
  ];
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "sha256-wDcBaNXIzOQ3/LBuW3YUnx/fjtJMeI+jsxLRBlsd1M0=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  makeIosevkaFont = set:
    let superBuildNpmPackage = buildNpmPackage; in
    (iosevka.override {
      inherit set privateBuildPlan;
      buildNpmPackage = args: superBuildNpmPackage
        (args // {
          pname = "iosevka-${set}";
          inherit version;

          src = fetchFromGitHub {
            owner = "be5invis";
            repo = "iosevka";
            rev = "v31.3.0";
            hash = "sha256-WrRxVrBJeyUwv0/DYTIHLi52+k2PilC7ay0tc5yq3Pw=";
          };

          npmDepsHash = "sha256-xw0GA1aIA/J5hfLQBSE+GJzXfbfWQI2k2pYdenlM9NY=";

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
