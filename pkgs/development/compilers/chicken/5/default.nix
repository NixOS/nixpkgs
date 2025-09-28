{
  lib,
  newScope,
  fetchurl,
}:
let
  # Some eggs mistakenly declare dependencies on modules which are part of chicken itself and thus
  # need not (and cannot) be installed as eggs. Instead of marking such eggs as broken, we remove
  # these invalid dependencies.
  invalidDependencies = [
    "srfi-4"
  ];
in
lib.makeScope newScope (self: {

  fetchegg =
    {
      pname,
      version,
      sha256,
      ...
    }:
    fetchurl {
      inherit sha256;
      url = "https://code.call-cc.org/egg-tarballs/5/${pname}/${pname}-${version}.tar.gz";
    };

  eggDerivation = self.callPackage ./eggDerivation.nix { };

  chicken = self.callPackage ./chicken.nix {
    bootstrap-chicken = self.chicken.override { bootstrap-chicken = null; };
  };

  chickenEggs = lib.recurseIntoAttrs (
    lib.makeScope self.newScope (
      eggself:
      (lib.mapAttrs (
        pname:
        eggData@{
          version,
          synopsis,
          dependencies,
          license,
          ...
        }:
        self.eggDerivation {
          inherit pname version;
          src = self.fetchegg (eggData // { inherit pname; });
          buildInputs = map (x: eggself.${x}) (lib.subtractLists invalidDependencies dependencies);
          meta.homepage = "https://wiki.call-cc.org/eggref/5/${pname}";
          meta.description = synopsis;
          meta.license =
            (
              lib.licenses
              // {
                "agpl" = lib.licenses.agpl3Only;
                "artistic" = lib.licenses.artistic2;
                "bsd" = lib.licenses.bsd3;
                "bsd-1-clause" = lib.licenses.bsd1;
                "bsd-2-clause" = lib.licenses.bsd2;
                "bsd-3-clause" = lib.licenses.bsd3;
                "gpl" = lib.licenses.gpl3Only;
                "gpl-2" = lib.licenses.gpl2Only;
                "gplv2" = lib.licenses.gpl2Only;
                "gpl-3" = lib.licenses.gpl3Only;
                "gpl-3.0" = lib.licenses.gpl3Only;
                "gplv3" = lib.licenses.gpl3Only;
                "lgpl" = lib.licenses.lgpl3Only;
                "lgpl-2" = lib.licenses.lgpl2Only;
                "lgpl-2.0+" = lib.licenses.lgpl2Plus;
                "lgpl-2.1" = lib.licenses.lgpl21Only;
                "lgpl-2.1-or-later" = lib.licenses.lgpl21Plus;
                "lgpl-3" = lib.licenses.lgpl3Only;
                "lgplv3" = lib.licenses.lgpl3Only;
                "public-domain" = lib.licenses.publicDomain;
                "srfi" = lib.licenses.bsd3;
                "unicode" = lib.licenses.ucd;
                "zlib-acknowledgement" = lib.licenses.zlib;
              }
            ).${license} or license;
        }
      ) (lib.importTOML ./deps.toml))
    )
  );

  egg2nix = self.callPackage ./egg2nix.nix { };

})
