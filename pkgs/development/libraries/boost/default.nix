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
  boost168 = makeBoost ./1.68.nix;
  boost169 = makeBoost ./1.69.nix;
  boost170 = makeBoost ./1.70.nix;
  boost172 = makeBoost ./1.72.nix;
  boost173 = makeBoost ./1.73.nix;
  boost174 = makeBoost ./1.74.nix;
  boost175 = makeBoost ./1.75.nix;
  boost177 = makeBoost ./1.77.nix;
  boost178 = makeBoost ./1.78.nix;
  boost179 = makeBoost ./1.79.nix;
  boost180 = makeBoost ./1.80.nix;
  boost181 = makeBoost ./1.81.nix;
  boost182 = makeBoost ./1.82.nix;
}
