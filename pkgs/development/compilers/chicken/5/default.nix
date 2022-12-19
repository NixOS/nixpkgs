{ lib, newScope, fetchzip }:
let
  callPackage = newScope self;

  self = with lib; {
    pkgs = self;

    fetchegg = { name, version, sha256, ... }:
      fetchzip {
        inherit sha256;
        name = "chicken-${name}-${version}-source";
        url =
          "https://code.call-cc.org/egg-tarballs/5/${name}/${name}-${version}.tar.gz";
      };

    eggDerivation = callPackage ./eggDerivation.nix { };

    chicken = callPackage ./chicken.nix {
      bootstrap-chicken = self.chicken.override { bootstrap-chicken = null; };
    };

    chickenEggs = recurseIntoAttrs (mapAttrs (name:
      eggData@{ version, synopsis, dependencies, license, ... }:
      self.eggDerivation {
        name = "chicken-${name}-${version}";
        src = self.fetchegg (eggData // { inherit name; });
        buildInputs = map (x: self.chickenEggs.${x}) dependencies;
        meta.homepage =
          "https://code.call-cc.org/cgi-bin/gitweb.cgi?p=eggs-5-latest.git;a=tree;f=${name}/${version}";
        meta.description = synopsis;
        meta.license = (licenses // {
          "bsd-2-clause" = licenses.bsd2;
          "bsd-3-clause" = licenses.bsd3;
          "public-domain" = licenses.publicDomain;
        }).${license} or license;
      }) (importJSON ./deps.json));

    egg2nix = callPackage ./egg2nix.nix { };
  };

in lib.recurseIntoAttrs self
