{stdenv, lib, nodejs, nodePackages, remarshal, ttfautohint-nox, fetchurl}:

let
  sets = [ "comfy" "comfy-fixed" "comfy-duo" "comfy-wide" "comfy-wide-fixed" ];
  privateBuildPlan = builtins.readFile ./comfy-private-build-plans.toml;
  overrideAttrs = (attrs: {
    version = "0.2.1";

    passthru = {
      updateScript = ./update-comfy.sh;
    };

    meta = with lib; {
      homepage = "https://github.com/protesilaos/iosevka-comfy";
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
  makeIosevkaFont = set: (import ./default.nix {
    inherit stdenv lib nodejs nodePackages remarshal ttfautohint-nox set privateBuildPlan;
  }).overrideAttrs overrideAttrs;
in
builtins.listToAttrs (builtins.map (set: {name=set; value=makeIosevkaFont set;}) sets)
