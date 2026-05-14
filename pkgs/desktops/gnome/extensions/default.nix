{
  lib,
  callPackage,
  config,
}:
let
  buildShellExtension = callPackage ./buildGnomeExtension.nix { };

  # Index of all scraped extensions (with supported versions)
  extensionsIndex = lib.importJSON ./extensions.json;

  # A list of UUIDs that have the same pname and we need to rename them
  extensionRenames = import ./extensionRenames.nix;

  # Take all extensions from the index that match the gnome version, build them and put them into a list of derivations
  produceExtensionsList =
    shell-version:
    lib.trivial.pipe extensionsIndex [
      # Does a given extension match our current shell version?
      (builtins.filter (extension: (builtins.hasAttr shell-version extension."shell_version_map")))
      # Take in an `extension` object from the JSON and transform it into the correct args to call `buildShellExtension`
      (map (extension: {
        inherit (extension)
          uuid
          name
          description
          link
          pname
          ;
        inherit (extension.shell_version_map.${shell-version}) version sha256 metadata;
      }))
      # Build them
      (map buildShellExtension)
    ];

  # Map the list of extensions to an attrset based on the UUID as key
  mapUuidNames =
    extensions:
    lib.trivial.pipe extensions [
      (map (extension: lib.nameValuePair extension.extensionUuid extension))
      builtins.listToAttrs
    ];

  # Map the list of extensions to an attrset based on the pname as key, which is more human readable than the UUID
  # We also take care of conflict renaming in here
  mapReadableNames =
    extensionsList:
    lib.trivial.pipe extensionsList [
      # Filter out all extensions that map to null
      (lib.filter (
        extension:
        !(
          (builtins.hasAttr extension.extensionUuid extensionRenames)
          && ((builtins.getAttr extension.extensionUuid extensionRenames) == null)
        )
      ))
      # Map all extensions to their pname, with potential overwrites
      (map (
        extension:
        lib.nameValuePair (extensionRenames.${extension.extensionUuid} or extension.extensionPortalSlug
        ) extension
      ))
      builtins.listToAttrs
    ];

in
rec {
  # Remember to import all these in all-packages.nix
  gnome38Extensions = mapUuidNames (produceExtensionsList "38");
  gnome40Extensions = mapUuidNames (produceExtensionsList "40");
  gnome41Extensions = mapUuidNames (produceExtensionsList "41");
  gnome42Extensions = mapUuidNames (produceExtensionsList "42");
  gnome43Extensions = mapUuidNames (produceExtensionsList "43");
  gnome44Extensions = mapUuidNames (produceExtensionsList "44");
  gnome45Extensions = mapUuidNames (produceExtensionsList "45");
  gnome46Extensions = mapUuidNames (produceExtensionsList "46");
  gnome47Extensions = mapUuidNames (produceExtensionsList "47");
  gnome48Extensions = mapUuidNames (produceExtensionsList "48");
  gnome49Extensions = mapUuidNames (produceExtensionsList "49");

  # Keep the last three versions in here
  gnomeExtensions = lib.trivial.pipe (gnome47Extensions // gnome48Extensions // gnome49Extensions) [
    # Apply some custom patches for automatically packaged extensions
    (callPackage ./extensionOverrides.nix { })
    # Add all manually packaged extensions
    (extensions: extensions // (import ./manuallyPackaged.nix { inherit callPackage; }))
    # Map the extension UUIDs to readable names
    (lib.attrValues)
    mapReadableNames
    # Add some aliases
    (
      extensions:
      extensions
      // lib.optionalAttrs config.allowAliases {
        unite-shell = gnomeExtensions.unite; # added 2021-01-19
        arc-menu = gnomeExtensions.arcmenu; # added 2021-02-14

        icon-hider = throw "gnomeExtensions.icon-hider was removed on 2024-03-15. The extension has not received any updates since 2020/3.34.";
        nohotcorner = throw "gnomeExtensions.nohotcorner removed since 2019-10-09: Since 3.34, it is a part of GNOME Shell configurable through GNOME Tweaks.";
        mediaplayer = throw "gnomeExtensions.mediaplayer deprecated since 2019-09-23: retired upstream https://github.com/JasonLG1979/gnome-shell-extensions-mediaplayer/blob/master/README.md";
        remove-dropdown-arrows = throw "gnomeExtensions.remove-dropdown-arrows removed since 2021-05-25: The extensions has not seen an update sine GNOME 3.34. Furthermore, the functionality it provides is obsolete as of GNOME 40.";
      }
    )
    # Export buildShellExtension function
    (extensions: extensions // { inherit buildShellExtension; })
    # Make the set "public"
    lib.recurseIntoAttrs
  ];

}
