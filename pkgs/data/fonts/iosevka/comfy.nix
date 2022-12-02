{ callPackage, lib, fetchFromSourcehut }:

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
  overrideAttrs = (attrs: {
    inherit version;

    meta = with lib; {
      inherit (src.meta) homepage;
      description = ''
        Customised build of the Iosevka typeface, with a consistent
        rounded style and overrides for almost all individual glyphs
        in both roman (upright) and italic (slanted) variants.
      '';
      license = licenses.ofl;
      platforms = attrs.meta.platforms;
      maintainers = [ maintainers.DamienCassou ];
    };
  });
  makeIosevkaFont = set:
    (callPackage ./. { inherit set privateBuildPlan; }).overrideAttrs
    overrideAttrs;
in builtins.listToAttrs (builtins.map (set: {
  name = set;
  value = makeIosevkaFont set;
}) sets)
