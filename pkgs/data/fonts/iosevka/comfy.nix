{ lib, iosevka, fetchFromSourcehut, fetchFromGitHub, buildNpmPackage }:

let
  sets = [
    # The compact, sans-serif set:
    "comfy"
    "comfy-fixed"
    "comfy-duo"
    # The compact, serif set:
    "comfy-motion"
    "comfy-motion-fixed"
    "comfy-motion-duo"
    # The wide, sans-serif set:
    "comfy-wide"
    "comfy-wide-fixed"
    "comfy-wide-duo"
  ];
  version = "1.1.0";
  src = fetchFromSourcehut {
    owner = "~protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "1h72my1s9pvxww6yijrvhy7hj9dspnshya60i60p1wlzr6d18v3p";
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
            rev = "ad1e247a3fb8d2e2561122e8e57dcdc86a23df77";
            hash = "sha256-sfItIMl9HOUykoZPsNKRGKwgkSWvNGUe3czHE8qFG5w=";
          };

          npmDepsHash = "sha256-HaO2q1f+hX3LjccuVCQaqQZCdUH9r7+jiFOR+3m8Suw=";

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
