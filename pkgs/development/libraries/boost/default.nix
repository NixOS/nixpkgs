{ lib
, callPackage
, boost-build
, fetchurl
}:

let
  makeBoost = file:
    lib.fix (self:
      callPackage file {
        boost-build = boost-build.override {
          # useBoost allows us passing in src and version from
          # the derivation we are building to get a matching b2 version.
          useBoost = self;
        };
      }
    );
in {
  boost177 = makeBoost ./1.77.nix;
  boost178 = makeBoost ./1.78.nix;
  boost179 = makeBoost ./1.79.nix;
  boost180 = makeBoost ./1.80.nix;
  boost181 = makeBoost ./1.81.nix;
  boost182 = makeBoost ./1.82.nix;
  boost183 = makeBoost ./1.83.nix;
  boost184 = makeBoost ./1.84.nix;
  boost185 = makeBoost ./1.85.nix;
  boost186 = makeBoost ./1.86.nix;
}
