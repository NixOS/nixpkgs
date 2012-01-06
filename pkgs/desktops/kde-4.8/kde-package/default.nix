{ callPackage, runCommand, stdenv, fetchurl, qt4, cmake, automoc4
, release, ignoreList, extraSubpkgs
}:

let
  inherit (stdenv.lib) filter fold;
  inherit (builtins) getAttr hasAttr remoteAttrs listToAttrs tail head;
in
rec {
  manifest = import (./. + "/${release}.nix");

  # src attribute for $name tarball
  kdesrc = name: fetchurl {
    url = "mirror://kde/" + (if manifest.stable then "" else "un")
      + "stable/${release}/src/${name}-${release}.tar.bz2";
    sha256 = getAttr name manifest.hashes;
  };

  # Default meta attribute
  defMeta = {
    homepage = http://www.kde.org;
    inherit (qt4.meta) platforms maintainers;
  };

  # KDE package built from the whole tarball
  # This function is used both for monolithic modules and modules which are
  # released as individual tarballs
  kdeMonoPkg = name: let n_ = name; in a@{meta, name ? n_, ...}:
    stdenv.mkDerivation ({
      name = "${name}-${release}";
      src = kdesrc name;
      meta = defMeta // meta;
      enableParallelBuilding = true;
    } // (removeAttrs a [ "meta" "name" ]));

  # kdeMonoPkg wrapper for modules splitted upstream compatible with combinePkgs
  # API.
  kdeSplittedPkg = module: {name, sane ? name}: kdeMonoPkg name;

  # Build subdirectory ${subdir} of tarball ${module}-${release}.tar.bz2
  kdeSubdirPkg = module:
    {name, subdir ? name, sane ? name}:
    let name_ = name; in
    a@{cmakeFlags ? [], name ? name_, meta ? {}, ...}:
    stdenv.mkDerivation ({
      name = "${name}-${release}";
      src = kdesrc module;
      cmakeFlags =
        [ "-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE"
          "-DBUILD_doc=TRUE"
          "-DBUILD_${subdir}=TRUE"
        ] ++ cmakeFlags;
      meta = defMeta // meta;
      enableParallelBuilding = true;
    } // (removeAttrs a [ "meta" "name" "cmakeFlags" ]));

  # A KDE monolithic module
  kdeMonoModule = name: path: callPackage path { kde = kdeMonoPkg name; };

  # Combine packages in one module.
  # Arguments:
  #  * pkgFun --- a function of the following signature:
  #               module: manifest_attrs: manual_attrs: derivation;
  #  * module --- name of the module
  #  * pkgs --- list of packages in manifest format
  combinePkgs = pkgFun: module: pkgs:
    let
      f = p@{name, ...}:
        callPackage (./.. + "/${module}/${name}.nix") { kde = pkgFun module p; };
      list = map f pkgs;
      attrs = listToAttrs (map
        ({name, sane ? name, ...}@p: { name = sane; value = f p; })
        pkgs);
    in
      runCommand "${module}-${release}"
      ({passthru = attrs // {
         propagatedUserEnvPackages = list;
         projects = attrs;
       };})
        ''
          mkdir -pv $out/nix-support
          echo "${toString list}" | tee $out/nix-support/propagated-user-env-packages
        '';

  # Given manifest module data, return the module
  kdeModule = { module, sane ? module, split, pkgs ? [] }:
    let
      pkgs_ = filterPkgs module pkgs;
    in
    # Module is splitted by upstream
    if split then combinePkgs kdeSplittedPkg module pkgs_
    # Monolithic module
    else if pkgs == [] then kdeMonoModule module (./.. + "/${module}.nix")
    # Module is splitted by us
    else combinePkgs kdeSubdirPkg module pkgs_;

  # The same, as nameValuePair with sane name
  kdeModuleNV = a@{ module, sane ? module, ... }:
    { name = sane; value = kdeModule a; };

  filterPkgs = module: (p:
      removeNames (stdenv.lib.attrByPath [module] [] ignoreList) p
      ++ (stdenv.lib.attrByPath [module] [] extraSubpkgs));

  # Remove attrsets with x.name in subst. Optimized for empty subst.
  removeNames = subst: big:
    fold (s: out: filter (x: x.name != s) out) big subst;

  modules = listToAttrs (map kdeModuleNV manifest.modules);

  splittedModuleList =
    let
      splitted = filter (a: a ? pkgs) manifest.modules;
      names = map ({module, sane ? module, ...}: sane) splitted;
    in
    map (m: m.projects) (stdenv.lib.attrVals names modules);

  individual =
    stdenv.lib.zipAttrsWith
    (
      name: list:
      if tail list == []
      then head list
      else abort "Multiple modules define ${name}"
    )
    splittedModuleList;
}
