{ callPackage, stdenv, fetchurl, qt47 } :

{
  recurseForRelease = true;

  inherit callPackage stdenv;

  qt4 = qt47;

  phonon = null;

  kde = callPackage ./kde-package { };

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
  kdesdk = {
    recurseForDerivations = true;
    cervisia = callPackage ./sdk/cervisia.nix { };
    kapptemplate = callPackage ./sdk/kapptemplate.nix { };
    kate = callPackage ./sdk/kate.nix { };
    kcachegrind = callPackage ./sdk/kcachegrind.nix { };
    kdeaccounts_plugin = callPackage ./sdk/kdeaccounts-plugin.nix { };
    dolphin_plugins = callPackage ./sdk/dolphin-plugins.nix { };
    kioslave_perldoc = callPackage ./sdk/kioslave-perldoc.nix { };
    kioslave_svn = callPackage ./sdk/kioslave-svn.nix { };
    strigi_analyzer = callPackage ./sdk/strigi-analyzer.nix { };
    kbugbuster = callPackage ./sdk/kbugbuster.nix { };
    kmtrace = callPackage ./sdk/kmtrace.nix { };
    kompare = callPackage ./sdk/kompare.nix { };
    kpartloader = callPackage ./sdk/kpartloader.nix { };
    kprofilemethod = callPackage ./sdk/kprofilemethod.nix { };
    kstartperf = callPackage ./sdk/kstartperf.nix { };
    kuiviewer = callPackage ./sdk/kuiviewer.nix { };
    lokalize = callPackage ./sdk/lokalize.nix { };
    poxml = callPackage ./sdk/poxml.nix { };
    scripts = callPackage ./sdk/scripts.nix { };
    umbrello = callPackage ./sdk/umbrello.nix { };
  };
  kdetoys = {
    recurseForDerivations = true;
    amor = callPackage ./toys/amor.nix { };
    kteatime = callPackage ./toys/kteatime.nix { };
    ktux = callPackage ./toys/ktux.nix { };
  };

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

  kdewebdev = {
    recurseForDerivations = true;
    klinkstatus = callPackage ./webdev/klinkstatus.nix { };
    kommander = callPackage ./webdev/kommander.nix { };
    kfilereplace = callPackage ./webdev/kfilereplace.nix { };
    kimagemapeditor = callPackage ./webdev/kimagemapeditor.nix { };
  };

  kdepim_runtime = callPackage ./pim-runtime { };
  kdepim = callPackage ./pim { };

  # Experimental 4.5 versions
  kdepim_runtime45 = callPackage ./pim-runtime45 { };
  kdepim45 = callPackage ./pim45 { };
### DEVELOPMENT

  kdebindings = callPackage ./bindings { };

  l10n = callPackage ./l10n { };
}
