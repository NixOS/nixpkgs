{ callPackage, callPackageOrig, stdenv, qt47 }:

let
  release = "4.7.4";

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
    kdebindings = [ "kimono" "korundum" "kross-interpreters" "perlkde" "perlqt"
      "qtruby" "qyoto" "smokekde" ];
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

  qt4 = qt47;

  kdebase_workspace = kde.modules.kde_workspace;

  inherit release;

  full = stdenv.lib.attrValues kde.modules;

  l10n = callPackage ./l10n { inherit release; };
}
