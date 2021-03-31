{ lib
, callPackage
, config
}:
let
  buildShellExtension = callPackage ./buildGnomeExtension.nix { };

  # Index of all scraped extensions (with supported versions)
  extensionsIndex = lib.importJSON ./extensions.json;

  # A list of UUIDs that have the same pname and we need to rename them
  # MAINTENANCE:
  # - Every item from ./collisions.json (for the respective Shell version) should have an entry in here
  # - Set the value to `null` for filtering (duplicate or unmaintained extensions)
  # - Sort the entries in order of appearance (check the number in the URL to their extensions.gnome.org page)
  extensionRenames = {
    "apps-menu@gnome-shell-extensions.gcampax.github.com" = "applications-menu";
    "Applications_Menu@rmy.pobox.com" = "frippery-applications-menu";

    "workspace-indicator@gnome-shell-extensions.gcampax.github.com" = "workspace-indicator";
    "horizontal-workspace-indicator@tty2.io" = "workspace-indicator-2";

    "lockkeys@vaina.lt" = "lock-keys";
    "lockkeys@fawtytoo" = "lock-keys-2";

    # See https://github.com/pbxqdown/gnome-shell-extension-transparent-window/issues/12#issuecomment-800765381
    "transparent-window@pbxqdown.github.com" = "transparent-window";
    "transparentwindows.mdirshad07" = null;

    "floatingDock@sun.wxg@gmail.com" = "floating-dock";
    "floating-dock@nandoferreira_prof@hotmail.com" = "floating-dock-2";
  };

  # Take all extensions from the index that match the gnome version, build them and put them into an attrset that is ready to go into nixpkgs
  produceExtensions = shell-version:
    lib.trivial.pipe extensionsIndex [
      # Does a given extension match our current shell version?
      (builtins.filter
        (extension: (builtins.hasAttr shell-version extension."shell_version_map"))
      )
      # Take in an `extension` object from the JSON and transform it into the correct args to call `buildShellExtension`
      (map
        (extension: {
          inherit (extension) uuid name description link pname;
          inherit (extension.shell_version_map.${shell-version}) version sha256;
        })
      )
      # Build them
      (map buildShellExtension)
    ];

  # Map the list of extensions to an attrset based on the UUID as key
  mapUuidNames = extensions:
    lib.trivial.pipe extensions [
      (map (extension: lib.nameValuePair extension.extensionUuid extension))
      builtins.listToAttrs
    ];

  # Map the list of extensions to an attrset based on the pname as key, which is more human readable than the UUID
  # We also take care of conflict renaming in here
  mapReadableNames = extensions: lib.trivial.pipe extensions [
    # Filter out all extensions that map to null
    (lib.filter (extension:
      !(
        (builtins.hasAttr extension.extensionUuid extensionRenames)
        && (isNull (builtins.getAttr extension.extensionUuid extensionRenames))
      )
    ))
    # Map all extensions to their pname
    (map (extension:
      let
        newName = if builtins.hasAttr extension.extensionUuid extensionRenames then
          builtins.getAttr extension.extensionUuid extensionRenames
        else
          extension.pname;
      in
        lib.nameValuePair newName extension
    ))
    builtins.listToAttrs
  ];

in rec {
  inherit buildShellExtension;

  gnome36Extensions = mapUuidNames (produceExtensions "36");
  gnome38Extensions = mapUuidNames (produceExtensions "38");

  gnomeExtensions = lib.recurseIntoAttrs ( (mapReadableNames (produceExtensions "38")) // {
    appindicator = callPackage ./appindicator { };
    arcmenu = callPackage ./arcmenu { };
    caffeine = callPackage ./caffeine { };
    clipboard-indicator = callPackage ./clipboard-indicator { };
    clock-override = callPackage ./clock-override { };
    dash-to-dock = callPackage ./dash-to-dock { };
    dash-to-panel = callPackage ./dash-to-panel { };
    draw-on-your-screen = callPackage ./draw-on-your-screen { };
    drop-down-terminal = callPackage ./drop-down-terminal { };
    dynamic-panel-transparency = callPackage ./dynamic-panel-transparency { };
    easyScreenCast = callPackage ./EasyScreenCast { };
    emoji-selector = callPackage ./emoji-selector { };
    freon = callPackage ./freon { };
    fuzzy-app-search = callPackage ./fuzzy-app-search { };
    gsconnect = callPackage ./gsconnect { };
    icon-hider = callPackage ./icon-hider { };
    impatience = callPackage ./impatience { };
    material-shell = callPackage ./material-shell { };
    mpris-indicator-button = callPackage ./mpris-indicator-button { };
    night-theme-switcher = callPackage ./night-theme-switcher { };
    no-title-bar = callPackage ./no-title-bar { };
    noannoyance = callPackage ./noannoyance { };
    paperwm = callPackage ./paperwm { };
    pidgin-im-integration = callPackage ./pidgin-im-integration { };
    remove-dropdown-arrows = callPackage ./remove-dropdown-arrows { };
    sound-output-device-chooser = callPackage ./sound-output-device-chooser { };
    system-monitor = callPackage ./system-monitor { };
    taskwhisperer = callPackage ./taskwhisperer { };
    tilingnome = callPackage ./tilingnome { };
    timepp = callPackage ./timepp { };
    topicons-plus = callPackage ./topicons-plus { };
    unite = callPackage ./unite { };
    window-corner-preview = callPackage ./window-corner-preview { };
    window-is-ready-remover = callPackage ./window-is-ready-remover { };
    workspace-matrix = callPackage ./workspace-matrix { };

    nohotcorner = throw "gnomeExtensions.nohotcorner removed since 2019-10-09: Since 3.34, it is a part of GNOME Shell configurable through GNOME Tweaks.";
    mediaplayer = throw "gnomeExtensions.mediaplayer deprecated since 2019-09-23: retired upstream https://github.com/JasonLG1979/gnome-shell-extensions-mediaplayer/blob/master/README.md";
  } // lib.optionalAttrs (config.allowAliases or false) {
    unite-shell = gnomeExtensions.unite; # added 2021-01-19
    arc-menu = gnomeExtensions.arcmenu; # added 2021-02-14
  });
}
