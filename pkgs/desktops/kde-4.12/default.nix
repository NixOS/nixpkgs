{ callPackage, callPackageOrig, stdenv, qt48, release ? "4.12.2" }:

let
  branch = "4.12";

  # Need callPackageOrig to avoid infinite cycle
  kde = callPackageOrig ./kde-package {
    inherit release branch ignoreList extraSubpkgs callPackage;
  };

  # The list of igored individual modules
  ignoreList = {
    # Doesn't work yet
    kdeutils = [ "ksecrets" ];
    # kdeadmin/strigi-analyzer has no real code
    kdeadmin = [ "strigi-analyzer" ];
    # Most of kdebindings do not compile due to a bug in the buildsystem
    kdebindings = [ "kimono" "korundum" "kross-interpreters" "perlkde" "qyoto" ];
  };

  # Extra subpackages in the manifest format
  extraSubpkgs = {};

in

kde.modules // kde.individual //
{
  inherit (kde) manifest modules individual splittedModuleList;

  akonadi = callPackage ./support/akonadi { };

  qt4 = qt48;

  kdebase_workspace = kde.modules.kde_workspace;

  inherit release;

  full = stdenv.lib.attrValues kde.modules;

  l10n = callPackage ./l10n {
    inherit release branch;
    inherit (kde.manifest) stable;
  };
}
