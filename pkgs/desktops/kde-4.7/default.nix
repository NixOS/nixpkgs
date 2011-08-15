{ callPackage, runCommand, stdenv, fetchurl, qt47, cmake, automoc4 }:

let
  release = "4.7.0";

  manifest = import (./kde-package + "/${release}.nix");

  kdesrc = name: fetchurl {
    url = "mirror://kde/" + (if manifest.stable then "" else "un")
      + "stable/${release}/src/${name}-${release}.tar.bz2";
    sha256 = builtins.getAttr name manifest.hashes;
  };

  mergeMeta = meta:
    {
      homepage = http://www.kde.org;
      inherit (qt47.meta) platforms maintainers;
    } // meta;

  kdeMonoPkg = name: a@{meta, ...}:
    stdenv.mkDerivation ({
        name = "${name}-${release}";
        src = kdesrc name;
        meta = mergeMeta meta;
        } // (builtins.removeAttrs a [ "meta" ]));
  kdeMonolithic = name: path: callPackage path { kde = kdeMonoPkg name; };

  kdeSubdirPkg = module:
    {name, subdir ? name, sane ? name}:
    let name_ = name; in
    a@{cmakeFlags ? [], name ? name_, ...}:
    stdenv.mkDerivation ({
      name = "${name}-${release}";
      src = kdesrc module;
      cmakeFlags = ["-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE"
      "-DBUILD_doc=TRUE" "-DBUILD_${subdir}=TRUE"] ++ cmakeFlags;
    } // (removeAttrs a [ "name" "cmakeFlags" ]));

  kdeSplittedPkg = module: {name, sane ? name}: kdeMonoPkg name;

  combinePkgs = pkgFun: module: pkgs:
    let
      f = p@{name, ...}:
        callPackage (./. + "/${module}/${name}.nix") { kde = pkgFun module p; };
      list = map f pkgs;
      attrs = builtins.listToAttrs (map
        ({name, sane ? name, ...}@p: { name = sane; value = f p; })
        pkgs);
    in
      runCommand "${module}-${release}"
      ({passthru = attrs // { propagatedUserEnvPackages = list; recurseForDerivations = true;};})
        ''
          mkdir -pv $out/nix-support
          echo "${toString list}" | tee $out/nix-support/propagated-user-env-packages
        '';

  kdeModule = { module, sane ? module, split, pkgs ? [] }:
    let pkgs_ = filterPkgs module pkgs; in
    {
      name = sane;
      value =
        # Module is splitted by upstream
        if split then combinePkgs kdeSplittedPkg module pkgs_
        # Monolithic module
        else if pkgs == [] then kdeMonolithic module (./. + "/${module}.nix")
        # Module is splitted by us
        else combinePkgs kdeSubdirPkg module pkgs_;
    };

  kdepkgs = builtins.listToAttrs (map kdeModule manifest.modules);

  filterPkgs = module: (p:
      removeNames (stdenv.lib.attrByPath [module] [] ignoreList) p
      ++ (stdenv.lib.attrByPath [module] [] extraSubpkgs));

# List difference, big - subst; optimised for empty subst
  removeNames = subst: big: stdenv.lib.fold (s: out: stdenv.lib.filter (x: x.name != s) out) big subst;

  ignoreList = {
    kdeadmin = [ "strigi-analyzer" ];
    kdesdk = [ "kioslave" ];
    kdebindings = [ "kimono" "korundum" "kross-interpreters" "perlkde" "perlqt"
      "qtruby" "qyoto" "smokekde" ];
  };

  extraSubpkgs = {
    kdesdk =
      [
      {
        name = "kioslave-svn";
        sane = "kioslave_svn";
        subdir = "kioslave";
      }
      {
        name = "kioslave-perldoc";
        sane = "kioslave_perldoc";
        subdir = "kioslave";
      }
      ];
  };

in
kdepkgs // kdepkgs.kdebase //
{
  recurseForRelease = true;
  akonadi = callPackage ./support/akonadi { };
  soprano = callPackage ./support/soprano { };

  qt4 = qt47;

  kdebase_workspace = kdepkgs.kdebase.kde_workspace;

# Propagate some libraries to the top-level
  inherit (kdepkgs.kdegraphics) libkdcraw libkipi libkexiv2 libksane;
  inherit (kdepkgs.kdebindings) pykde4;
  inherit (kdepkgs.kdeedu) libkdeedu;

  inherit release;

  full = stdenv.lib.attrValues kdepkgs;

  l10n = callPackage ./l10n { inherit release; };

  subdirNames = map (x: x.module) (stdenv.lib.filter (x: !x.split && (x ? pkgs)) manifest.modules);
}
