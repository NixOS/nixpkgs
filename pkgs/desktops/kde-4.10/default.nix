{ callPackage, callPackageOrig, stdenv, qt48, release ? "4.10.5" }:

let
  branch = "4.10";
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
    # fake package to make things just work
    kdesdk = [ "fake" ];
    # Most of kdebindings do not compile due to a bug in the buildsystem
    kdebindings = [ "kimono" "korundum" "kross-interpreters" "perlkde" "qyoto" ];
  };

  # Extra subpackages in the manifest format
  extraSubpkgs = {
    kdesdk = [
      { name="cervisia"; }
      { name="lokalize"; }
      { name = "kioslave-svn"; sane = "kioslave_svn"; subdir = "kdesdk-kioslaves"; }
      { name = "kioslave-perldoc"; sane = "kioslave_perldoc"; subdir = "kdesdk-kioslaves"; }
      { name="dolphin-plugins-svn"; sane="dolphin_plugins_svn";subdir="dolphin-plugins"; }
      { name="dolphin-plugins-git"; sane="dolphin_plugins_git";subdir="dolphin-plugins"; }
      { name="dolphin-plugins-hg"; sane="dolphin_plugins_hg";subdir="dolphin-plugins"; }
      { name="dolphin-plugins-bazaar"; sane="dolphin_plugins_bazaar";subdir="dolphin-plugins"; }
      { name="kcachegrind"; }
      { name="kapptemplate"; }
      { name="kdesdk-strigi-analyzers"; sane="kdesdk_strigi_analyzers";}
      { name="kdesdk-thumbnailers"; sane="kdesdk_thumbnailers";}
      { name="okteta"; }
      { name="kompare"; }
      { name="poxml"; }
      { name="kde-dev-scripts"; sane = "kde_dev_scripts"; }
      { name="kde-dev-utils"; sane="kde_dev_utils";}
      #{ name="kprofilemethod"; subdir = "kde-dev-utils/kprofilemethod";}
      #{ name="kstartperf"; }
      #{ name="kmtrace"; subdir = "kde-dev-utils/kmtrace"; }
      #{ name="kpartloader"; }
      #{ name="kuiviewer"; }
      { name="umbrello"; }
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
    inherit release branch;
    inherit (kde.manifest) stable;
  };
}
