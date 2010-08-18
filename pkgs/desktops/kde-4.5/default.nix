{ callPackage, stdenv, fetchurl } :

{
  recurseForRelease = true;

  kdePackage = import ./kde-package {
    inherit stdenv fetchurl;
  };

### SUPPORT
  akonadi = callPackage ./support/akonadi { };

  attica = callPackage ./support/attica { };

  automoc4 = callPackage ./support/automoc4 { };

  eigen = callPackage ./support/eigen { };

  oxygen_icons = callPackage ./support/oxygen-icons { };

  polkit_qt_1 = callPackage ./support/polkit-qt-1 { };

  strigi = callPackage ./support/strigi { };

  soprano = callPackage ./support/soprano { };

  qca2 = callPackage ./support/qca2 { };

  qca2_ossl = callPackage ./support/qca2/ossl.nix { };

  qimageblitz = callPackage ./support/qimageblitz { };

### LIBS
  kdelibs = callPackage ./libs { };

  kdepimlibs = callPackage ./pimlibs { };

### BASE
  kdebase = callPackage ./base { };

  kdebase_workspace = callPackage ./base-workspace { };

  kdebase_runtime = callPackage ./base-runtime { };

### OTHER MODULES
  kdeaccessibility = callPackage ./accessibility { };
  kdeartwork = callPackage ./artwork { };
  kdeedu = callPackage ./edu { };
  kdegames = callPackage ./games { };
  kdegraphics = callPackage ./graphics { };
  kdemultimedia = callPackage ./multimedia { };
  kdenetwork = callPackage ./network { };
  kdeplasma_addons = callPackage ./plasma-addons { };
  kdetoys = callPackage ./toys { };
  kdeutils = callPackage ./utils { };
### DEVELOPMENT

  kdebindings = callPackage ./bindings { };
  
}
