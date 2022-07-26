{ lib
, ddcutil
, gjs
, gnome
, gobject-introspection
, hddtemp
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
, vte
, wrapGAppsHook
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

  (patchExtension "screen-autorotate@kosmospredanie.yandex.ru" (old: {
    # Requires gjs
    # https://github.com/NixOS/nixpkgs/issues/164865
    postPatch = ''
      for file in *.js; do
        substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
      done
    '';
  }))

  (patchExtension "shell-volume-mixer@derhofbauer.at" (old: {
    patches = [
      (substituteAll {
        src = ./extensionOverridesPatches/shell-volume-mixer_at_derhofbauer.at.patch;
        inherit pulseaudio;
        inherit python3;
      })
    ];

    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
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
