{ callPackage, callPackageOrig, stdenv, qt48, release ? "4.14.3", kdelibs }:

let
  branch = "4.14";

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
  akonadi = callPackage ./support/akonadi { };

  inherit release;

  l10n = callPackage ./l10n {
    inherit release branch;
    inherit (kde.manifest) stable;
  };
}
