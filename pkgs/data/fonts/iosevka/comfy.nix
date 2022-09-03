{ callPackage, lib, fetchFromSourcehut }:

let
  sets = [
    "comfy"
    "comfy-fixed"
    "comfy-duo"
    "comfy-wide"
    "comfy-wide-fixed"
    "comfy-motion"
    "comfy-motion-duo"
  ];
  version = "0.4.0";
  src = fetchFromSourcehut {
    owner = "~protesilaos";
    repo = "iosevka-comfy";
    rev = version;
    sha256 = "sha256-d3C5HNiZCd0xva6zvMP9NmvmeU4uXuaO04pbgIepwfw=";
  };
  privateBuildPlan = src.outPath + "/private-build-plans.toml";
  overrideAttrs = (attrs: {
    inherit version;

    meta = with lib; {
      inherit (src.meta) homepage;
      description = ''
        Custom build of Iosevka with a rounded style and open shapes,
        adjusted metrics, and overrides for almost all individual glyphs
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
