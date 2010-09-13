{ callPackage, stdenv, fetchurl, qt47 } :

{
  recurseForRelease = true;

  inherit callPackage;

  qt4 = qt47;

  phonon = null;

  kde = import ./kde-package {
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
  kdeaccessibility = {
    recurseForDerivations = true;
    colorSchemes = callPackage ./accessibility/color-schemes.nix { };
    iconThemes = callPackage ./accessibility/icon-themes.nix { };
    jovie = callPackage ./accessibility/jovie.nix { };
    kmag = callPackage ./accessibility/kmag.nix { };
    kmousetool = callPackage ./accessibility/kmousetool.nix { };
    kmouth = callPackage ./accessibility/kmouth.nix { };
  };

  kdeadmin = callPackage ./admin { };
  kdeartwork = {
    recurseForDerivations = true;
    aurorae = callPackage ./artwork/aurorae.nix { };
    colorSchemes = callPackage ./artwork/color-schemes.nix { };
    desktop_themes = callPackage ./artwork/desktop-themes.nix { };
    emoticons = callPackage ./artwork/emoticons.nix { };
    high_resolution_wallpapers = callPackage ./artwork/high-resolution-wallpapers.nix { };
    wallpapers = callPackage ./artwork/wallpapers.nix { };
    nuvola_icon_theme = callPackage ./artwork/nuvola-icon-theme.nix { };
    sounds = callPackage ./artwork/sounds.nix { };
    weather_wallpapers = callPackage ./artwork/weather-wallpapers.nix { };
    phase_style = callPackage ./artwork/phase-style.nix { };
    kscreensaver = callPackage ./artwork/kscreensaver.nix { };
  };
  kdeedu = callPackage ./edu { };
  kdegames = callPackage ./games { };
  kdegraphics = callPackage ./graphics { };
  kdemultimedia = callPackage ./multimedia { };
  kdenetwork = callPackage ./network { };
  kdeplasma_addons = callPackage ./plasma-addons { };
  kdesdk = callPackage ./sdk { };
  kdetoys = callPackage ./toys { };

  kdeutils = {
    ark = callPackage ./utils/ark.nix { };
    kcalc = callPackage ./utils/kcalc.nix { };
    kcharselect = callPackage ./utils/kcharselect.nix { };
    kdf = callPackage ./utils/kdf.nix { };
    kfloppy = callPackage ./utils/kfloppy.nix { };
    kgpg = callPackage ./utils/kgpg.nix { };
    kremotecontrol = callPackage ./utils/kremotecontrol.nix { };
    ktimer = callPackage ./utils/ktimer.nix { };
    kwallet = callPackage ./utils/kwallet.nix { };
    okteta = callPackage ./utils/okteta.nix { };
    printer_applet = callPackage ./utils/printer-applet.nix { };
    superkaramba = callPackage ./utils/superkaramba.nix { };
    sweeper = callPackage ./utils/sweeper.nix { };
    recurseForRelease = true;
  };

  kdewebdev = callPackage ./webdev { };

  #kdepim_runtime = callPackage ../kde-4.4/pim-runtime { };
  kdepim_runtime = callPackage ./pim-runtime { };
  kdepim = callPackage ./pim { };
### DEVELOPMENT

  kdebindings = callPackage ./bindings { };
}
