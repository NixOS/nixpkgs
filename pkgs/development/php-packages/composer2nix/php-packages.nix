{ composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null }:

let
  packages = {
    "svanderburg/composer2nix" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "svanderburg-composer2nix-299caca4aac42d7639a42eb4dde951c010f6e91c";
        src = fetchurl {
          url = https://api.github.com/repos/svanderburg/composer2nix/zipball/299caca4aac42d7639a42eb4dde951c010f6e91c;
          sha256 = "sha256-wHPovTvCFXzUNtQ5eOZldL202YNnF0b+Vwl9oz7BZ20=";
        };
      };
    };
    "svanderburg/pndp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "svanderburg-pndp-bc795b341d95c24bb577e0d7a4a37fde98b1cce8";
        src = fetchurl {
          url = https://api.github.com/repos/svanderburg/pndp/zipball/bc795b341d95c24bb577e0d7a4a37fde98b1cce8;
          sha256 = "sha256-kYjVSck6eLtWbMye7LsCT2d27uJ0rsCC3rNxyZjmhvg=";
        };
      };
    };
  };
  devPackages = {};
in {
  inherit packages devPackages;
}
