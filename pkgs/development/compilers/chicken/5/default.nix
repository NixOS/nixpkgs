{ lib, newScope, fetchurl }:
let
  callPackage = newScope self;

  self = with lib; {
    inherit callPackage;

    fetchegg = { pname, version, sha256, ... }:
      fetchurl {
        inherit sha256;
        url =
          "https://code.call-cc.org/egg-tarballs/5/${pname}/${pname}-${version}.tar.gz";
      };

    eggDerivation = callPackage ./eggDerivation.nix { };

    chicken = callPackage ./chicken.nix {
      bootstrap-chicken = self.chicken.override { bootstrap-chicken = null; };
    };

    chickenEggs = recurseIntoAttrs (mapAttrs (pname:
      eggData@{ version, synopsis, dependencies, license, ... }:
      self.eggDerivation {
        name = "${pname}-${version}";
        src = self.fetchegg (eggData // { inherit pname; });
        buildInputs = map (x: self.chickenEggs.${x}) dependencies;
        meta.homepage =
          "https://code.call-cc.org/cgi-bin/gitweb.cgi?p=eggs-5-latest.git;a=tree;f=${pname}/${version}";
        meta.description = synopsis;
        meta.license = (licenses // {
          "bsd-2-clause" = licenses.bsd2;
          "bsd-3-clause" = licenses.bsd3;
          "public-domain" = licenses.publicDomain;
        }).${license} or license;
      }) (importTOML ./deps.toml));

    egg2nix = callPackage ./egg2nix.nix { };
  };

in lib.recurseIntoAttrs self
