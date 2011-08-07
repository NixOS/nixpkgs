{ callPackage, recurseIntoAttrs, runCommand, stdenv, fetchurl, qt47, system_config_printer, boost } @ args:

let

  release = "4.7.0";

  # Various packages (e.g. kdesdk) have been split up into many
  # smaller packages.  Some people may want to install the entire
  # package, so provide a wrapper package that recombines them.
  combinePkgs = name: pkgs:
    let pkgs' = stdenv.lib.attrValues pkgs; in
    runCommand "${name}-${release}" ({ passthru = pkgs // { inherit pkgs; }; })
      ''
        mkdir -p $out/nix-support
        echo ${toString pkgs'} > $out/nix-support/propagated-user-env-packages
      '';

in

recurseIntoAttrs rec {
  recurseForRelease = true;

  inherit callPackage stdenv;

  qt4 = qt47;

  kde = callPackage ./kde-package { inherit release; stable = true; };

### SUPPORT

  system_config_printer = args.system_config_printer.override { withGUI = false; };

  akonadi = callPackage ./support/akonadi { };

  oxygen_icons = callPackage ./support/oxygen-icons { };

  soprano = callPackage ./support/soprano { };

  libkexiv2 = callPackage ./libkexiv2.nix { };

  libkipi = callPackage ./libkipi.nix { };

  libkdcraw = callPackage ./libkdcraw.nix { };

  kipi_plugins = callPackage ./kipi-plugins.nix { };

### LIBS

  kdelibs = callPackage ./libs { };

  kdepimlibs = callPackage ./pimlibs.nix { };

### BASE

  kde_baseapps = callPackage ./baseapps.nix { };

  kde_workspace = callPackage ./workspace.nix { };

  kde_runtime = callPackage ./runtime.nix { };

  # Backwards compatibility.
  kdebase_workspace = kde_workspace;

### BINDINGS

  pykde4 = callPackage ./pykde4.nix { };

### OTHER MODULES

  konsole = callPackage ./konsole.nix { };

  kcolorchooser = callPackage ./kcolorchooser.nix { };

  kate = callPackage ./kate.nix { };

  kde_wallpapers = callPackage ./wallpapers.nix { };

  kdeadmin = callPackage ./admin.nix { };

  kdegames = callPackage ./games.nix { };
  
  kdemultimedia = callPackage ./multimedia.nix { };

  kdeaccessibility = combinePkgs "kdeaccessibility" {
    #jovie = callPackage ./accessibility/jovie.nix { };
    kmag = callPackage ./accessibility/kmag.nix { };
    kmousetool = callPackage ./accessibility/kmousetool.nix { };
    kmouth = callPackage ./accessibility/kmouth.nix { };
    kaccessible = callPackage ./accessibility/kaccessible.nix { };
  };

  kdeartwork = combinePkgs "kdeartwork" {
    aurorae = callPackage ./artwork/aurorae.nix { };
    color_schemes = callPackage ./artwork/color-schemes.nix { };
    desktop_themes = callPackage ./artwork/desktop-themes.nix { };
    emoticons = callPackage ./artwork/emoticons.nix { };
    high_resolution_wallpapers = callPackage ./artwork/high-resolution-wallpapers.nix { };
    wallpapers = callPackage ./artwork/wallpapers.nix { };
    nuvola_icon_theme = callPackage ./artwork/nuvola-icon-theme.nix { };
    sounds = callPackage ./artwork/sounds.nix { };
    weather_wallpapers = callPackage ./artwork/weather-wallpapers.nix { };
    phase_style = callPackage ./artwork/phase-style.nix { };
    kscreensaver = callPackage ./artwork/kscreensaver.nix { };
    kwin_styles = callPackage ./artwork/kwin-styles.nix { };
  };
  
  /*
  kdeedu = callPackage ./edu { };
  kdenetwork = callPackage ./network { };
  kdeplasma_addons = callPackage ./plasma-addons { };
  */

  kdeedu = combinePkgs "kdeedu" {
    klettres = callPackage ./edu/klettres.nix { };
    kmplot = callPackage ./edu/kmplot.nix { };
    kstars = callPackage ./edu/kstars.nix { };
    rocs = callPackage ./edu/rocs.nix {
      boost = args.boost.override {enableExceptions = true;};
    };
    step = callPackage ./edu/step.nix { };
  };

  kdegraphics = combinePkgs "kdegraphics" {
    gwenview = callPackage ./graphics/gwenview.nix { };
    kamera = callPackage ./graphics/kamera.nix { };
    kgamma = callPackage ./graphics/kgamma.nix { };
    kolourpaint = callPackage ./graphics/kolourpaint.nix { };
    kruler = callPackage ./graphics/kruler.nix { };
    ksnapshot = callPackage ./graphics/ksnapshot.nix { };
    okular = callPackage ./graphics/okular.nix { };
  };

  kdesdk = combinePkgs "kdesdk" {
    cervisia = callPackage ./sdk/cervisia.nix { };
    kapptemplate = callPackage ./sdk/kapptemplate.nix { };
    kcachegrind = callPackage ./sdk/kcachegrind.nix { };
    kdeaccounts_plugin = callPackage ./sdk/kdeaccounts-plugin.nix { };
    dolphin_plugins = callPackage ./sdk/dolphin-plugins.nix { };
    kioslave_perldoc = callPackage ./sdk/kioslave-perldoc.nix { };
    kioslave_svn = callPackage ./sdk/kioslave-svn.nix { };
    strigi_analyzer = callPackage ./sdk/strigi-analyzer.nix { };
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
    okteta = callPackage ./sdk/okteta.nix { };
  };

  kdetoys = combinePkgs "kdetoys" {
    amor = callPackage ./toys/amor.nix { };
    kteatime = callPackage ./toys/kteatime.nix { };
    ktux = callPackage ./toys/ktux.nix { };
  };

  kdeutils = combinePkgs "kdeutils" {
    ark = callPackage ./utils/ark.nix { };
    kcalc = callPackage ./utils/kcalc.nix { };
    kcharselect = callPackage ./utils/kcharselect.nix { };
    kdf = callPackage ./utils/kdf.nix { };
    kfloppy = callPackage ./utils/kfloppy.nix { };
    kgpg = callPackage ./utils/kgpg.nix { };
    kremotecontrol = callPackage ./utils/kremotecontrol.nix { };
    ktimer = callPackage ./utils/ktimer.nix { };
    kwallet = callPackage ./utils/kwallet.nix { };
    printer_applet = callPackage ./utils/printer-applet.nix { };
    superkaramba = callPackage ./utils/superkaramba.nix { };
    sweeper = callPackage ./utils/sweeper.nix { };
    filelight = callPackage ./utils/filelight.nix { };
  };

  kdewebdev = combinePkgs "kdewebdev" {
    klinkstatus = callPackage ./webdev/klinkstatus.nix { };
    kommander = callPackage ./webdev/kommander.nix { };
    kfilereplace = callPackage ./webdev/kfilereplace.nix { };
    kimagemapeditor = callPackage ./webdev/kimagemapeditor.nix { };
  };

  kdepim_runtime = callPackage ./pim-runtime.nix { };
  
  kdepim = callPackage ./pim.nix { };

### DEVELOPMENT

  /*
  kdebindings = callPackage ./bindings { };
  */

  l10n = callPackage ./l10n { inherit release; };

  # Make the split packages visible to `nix-env -q'.
  misc = recurseIntoAttrs
    (kdeaccessibility.pkgs // kdeartwork.pkgs // kdesdk.pkgs // kdetoys.pkgs // kdeutils.pkgs // kdewebdev.pkgs);

}
