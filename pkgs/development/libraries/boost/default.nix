{ lib
, stdenv
, llvmPackages_7
, callPackage
, boost-build
, fetchurl
}:

let
  # Older boost versions (< 1.6.9) require clang < 8
  compatibleStdenv =
    if stdenv.cc.isClang && !(lib.versionOlder stdenv.cc.version "8.0.0")
    then llvmPackages_7.stdenv
    else stdenv;

  # for boost 1.55 we need to use 1.56's b2
  # since 1.55's build system is not working
  # with our derivation
  useBoost156 = rec {
    version = "1.56.0";
    src = fetchurl {
      url = "mirror://sourceforge/boost/boost_${lib.replaceStrings ["."] ["_"] version}.tar.bz2";
      sha256 = "07gz62nj767qzwqm3xjh11znpyph8gcii0cqhnx7wvismyn34iqk";
    };
  };

  makeBoost = file: args:
    lib.fix (self:
      callPackage file (args // {
        boost-build = boost-build.override {
          # useBoost allows us passing in src and version from
          # the derivation we are building to get a matching b2 version.
          useBoost =
            if lib.versionAtLeast self.version "1.56"
            then self
            else useBoost156; # see above
        };
      })
    );
in {
  boost155 = makeBoost ./1.55.nix { stdenv = compatibleStdenv; };
  boost159 = makeBoost ./1.59.nix { stdenv = compatibleStdenv; };
  boost160 = makeBoost ./1.60.nix { stdenv = compatibleStdenv; };
  boost165 = makeBoost ./1.65.nix { stdenv = compatibleStdenv; };
  boost166 = makeBoost ./1.66.nix { stdenv = compatibleStdenv; };
  boost167 = makeBoost ./1.67.nix { stdenv = compatibleStdenv; };
  boost168 = makeBoost ./1.68.nix { stdenv = compatibleStdenv; };
  boost169 = makeBoost ./1.69.nix {};
  boost170 = makeBoost ./1.70.nix {};
  boost171 = makeBoost ./1.71.nix {};
  boost172 = makeBoost ./1.72.nix {};
  boost173 = makeBoost ./1.73.nix {};
  boost174 = makeBoost ./1.74.nix {};
  boost175 = makeBoost ./1.75.nix {};
  boost177 = makeBoost ./1.77.nix {};
}
