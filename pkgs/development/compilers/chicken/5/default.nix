{ lib, newScope, fetchurl }:

lib.makeScope newScope (self: {

  fetchegg = { pname, version, sha256, ... }:
    fetchurl {
      inherit sha256;
      url =
        "https://code.call-cc.org/egg-tarballs/5/${pname}/${pname}-${version}.tar.gz";
    };

  eggDerivation = self.callPackage ./eggDerivation.nix { };

  chicken = self.callPackage ./chicken.nix {
    bootstrap-chicken = self.chicken.override { bootstrap-chicken = null; };
  };

  chickenEggs = lib.recurseIntoAttrs (lib.makeScope self.newScope (eggself:
    (lib.mapAttrs
      (pname:
        eggData@{ version, synopsis, dependencies, license, ... }:
        self.eggDerivation {
          name = "${pname}-${version}";
          src = self.fetchegg (eggData // { inherit pname; });
          buildInputs = map (x: eggself.${x}) dependencies;
          meta.homepage =
            "https://code.call-cc.org/cgi-bin/gitweb.cgi?p=eggs-5-latest.git;a=tree;f=${pname}/${version}";
          meta.description = synopsis;
          meta.license = (lib.licenses // {
            "bsd-1-clause" = lib.licenses.bsd1;
            "bsd-2-clause" = lib.licenses.bsd2;
            "bsd-3-clause" = lib.licenses.bsd3;
            "lgpl-2.0+" = lib.licenses.lgpl2Plus;
            "lgpl-2.1-or-later" = lib.licenses.lgpl21Plus;
            "public-domain" = lib.licenses.publicDomain;
          }).${license} or license;
        })
      (lib.importTOML ./deps.toml))));

  egg2nix = self.callPackage ./egg2nix.nix { };

})
