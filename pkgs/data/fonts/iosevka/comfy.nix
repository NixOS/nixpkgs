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
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromSourcehut {
    owner = "~protesilaos";
    repo = "iosevka-comfy";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ajzUbobNf+Je8ls9htOCLPsB0OPSiqZzrc8bO6hQvio=";
=======
    sha256 = "sha256-gHDERf3eDsb59wz+kGa2wLY7RDRWs2woi5P2rZDYjL0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
            rev = "7ef24b8d87fe50793444f9f84b140767f7e47029";
            hash = "sha256-RVBgJVMNyxV1KeNniwySsJUOmLDh6sFZju8szvzKlH4=";
          };

          npmDepsHash = "sha256-yogUBf+yfjfK8DE4gGgoGaTaYZagW8R1pCn7y0rEPt4=";
=======
            rev = "d3b461432137b36922e41322c2e45a2401e727a5";
            hash = "sha256-Sm+eG6ovVLmvKvQFEZblQV3jCLQRrc9Gga3pukwteLE=";
          };

          npmDepsHash = "sha256-pikpi9eyo1a+AFLr7BMl1kegy3PgYFjzmE3QJqPXpNM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
