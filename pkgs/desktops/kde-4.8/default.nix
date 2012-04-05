{ callPackage, callPackageOrig, stdenv, qt48 }:

let
  release = "4.8.2";

  # Need callPackageOrig to avoid infinite cycle
  kde = callPackageOrig ./kde-package {
    inherit release ignoreList extraSubpkgs callPackage;
  };

  # The list of igored individual modules
  ignoreList = {
    # kdeadmin/strigi-analyzer has no real code
    kdeadmin = [ "strigi-analyzer" ];
    # kdesdk/kioslave is splitted into kioslave-svn and kioslave-git
    kdesdk = [ "kioslave" ];
    # Most of kdebindings do not compile due to a bug in the buildsystem
    kdebindings = [ "kimono" "korundum" "kross-interpreters" "perlkde" "qyoto" ];
  };

  # Extra subpackages in the manifest format
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

kde.modules // kde.individual //
{
  inherit (kde) manifest modules individual splittedModuleList;

  akonadi = callPackage ./support/akonadi { };

  qt4 = qt48;

  kdebase_workspace = kde.modules.kde_workspace;

  inherit release;

  full = stdenv.lib.attrValues kde.modules;

  l10n = callPackage ./l10n {
    inherit release;
    inherit (kde.manifest) stable;
  };
}
