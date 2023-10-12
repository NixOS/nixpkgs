{ lib
, ddcutil
, easyeffects
, gjs
, glib
, gnome
, gobject-introspection
, gsound
, hddtemp
, libgda
, libgtop
, liquidctl
, lm_sensors
, netcat-gnu
, nvme-cli
, procps
, pulseaudio
, python3
, smartmontools
, substituteAll
, touchegg
, util-linux
, vte
, wrapGAppsHook
, xdg-utils
, xprop
}:
let
  # Helper method to reduce redundancy
  patchExtension = name: override: super: (super // {
    ${name} = super.${name}.overrideAttrs override;
  });
in
# A set of overrides for automatically packaged extensions that require some small fixes.
# The input must be an attribute set with the extensions' UUIDs as keys and the extension
# derivations as values. Output is the same, but with patches applied.
#
# Note that all source patches refer to the built extension as published on extensions.gnome.org, and not
# the upstream repository's sources.
super: lib.trivial.pipe super [
  (patchExtension "caffeine@patapon.info" (old: {
    meta.maintainers = with lib.maintainers; [ eperuffo ];
  }))

  (patchExtension "dash-to-dock@micxgx.gmail.com" (old: {
    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
  }))

  (patchExtension "ddterm@amezin.github.com" (old: {
    # Requires gjs, zenity & vte via the typelib
    nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
    buildInputs = [ vte ];
    postPatch = ''
      for file in *.js com.github.amezin.ddterm; do
        substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
        substituteInPlace $file --replace "zenity" "${gnome.zenity}/bin/zenity"
      done
    '';
    postFixup = ''
      wrapGApp "$out/share/gnome-shell/extensions/ddterm@amezin.github.com/com.github.amezin.ddterm"
    '';
  }))

  (patchExtension "display-brightness-ddcutil@themightydeity.github.com" (old: {
    # Has a hard-coded path to a run-time dependency
    # https://github.com/NixOS/nixpkgs/issues/136111
    postPatch = ''
      substituteInPlace "extension.js" --replace "/usr/bin/ddcutil" "${ddcutil}/bin/ddcutil"
    '';
  }))

  (patchExtension "eepresetselector@ulville.github.io" (old: {
    patches = [
      # Needed to find the currently set preset
      (substituteAll {
        src = ./extensionOverridesPatches/eepresetselector_at_ulville.github.io.patch;
        easyeffects_gsettings_path = "${glib.getSchemaPath easyeffects}";
      })
    ];
  }))

  (patchExtension "freon@UshakovVasilii_Github.yahoo.com" (old: {
    patches = [
      (substituteAll {
        src = ./extensionOverridesPatches/freon_at_UshakovVasilii_Github.yahoo.com.patch;
        inherit hddtemp liquidctl lm_sensors procps smartmontools;
        netcat = netcat-gnu;
        nvmecli = nvme-cli;
      })
    ];
  }))

  (patchExtension "gnome-shell-screenshot@ttll.de" (old: {
    # Requires gjs
    # https://github.com/NixOS/nixpkgs/issues/136112
    postPatch = ''
      for file in *.js; do
        substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
      done
    '';
  }))

  (patchExtension "gtk4-ding@smedius.gitlab.com" (old: {
    patches = [
      (substituteAll {
        inherit gjs util-linux xdg-utils;
        util_linux = util-linux;
        xdg_utils = xdg-utils;
        src = ./extensionOverridesPatches/gtk4-ding_at_smedius.gitlab.com.patch;
        nautilus_gsettings_path = "${glib.getSchemaPath gnome.nautilus}";
      })
    ];
  }))

  (patchExtension "pano@elhan.io" (old: {
    patches = [
      (substituteAll {
        src = ./extensionOverridesPatches/pano_at_elhan.io.patch;
        inherit gsound libgda;
      })
    ];
  }))

  (patchExtension "tophat@fflewddur.github.io" (old: {
    patches = [
      (substituteAll {
        src = ./extensionOverridesPatches/tophat_at_fflewddur.github.io.patch;
        gtop_path = "${libgtop}/lib/girepository-1.0";
      })
    ];
  }))

  (patchExtension "Vitals@CoreCoding.com" (old: {
    patches = [
      (substituteAll {
        src = ./extensionOverridesPatches/vitals_at_corecoding.com.patch;
        gtop_path = "${libgtop}/lib/girepository-1.0";
      })
    ];
  }))

  (patchExtension "unite@hardpixel.eu" (old: {
    buildInputs = [ xprop ];

    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
  }))

  (patchExtension "x11gestures@joseexposito.github.io" (old: {
    # Extension can't find Touchegg
    # https://github.com/NixOS/nixpkgs/issues/137621
    postPatch = ''
      substituteInPlace "src/touchegg/ToucheggConfig.js" \
        --replace "GLib.build_filenamev([GLib.DIR_SEPARATOR_S, 'usr', 'share', 'touchegg', 'touchegg.conf'])" "'${touchegg}/share/touchegg/touchegg.conf'"
    '';
  }))
]
