{
  lib,
  fetchFromGitLab,
  cpio,
  ddcutil,
  easyeffects,
  gjs,
  glib,
  gnome-menus,
  nautilus,
  gobject-introspection,
  hddtemp,
  libgtop,
  libhandy,
  liquidctl,
  lm_sensors,
  netcat-gnu,
  nvme-cli,
  procps,
  smartmontools,
  replaceVars,
  stdenvNoCC,
  touchegg,
  util-linux,
  vte,
  wrapGAppsHook3,
  xdg-utils,
  gtk4,
  desktop-file-utils,
  xdg-user-dirs,
}:
let
  # Helper method to reduce redundancy
  patchExtension =
    name: override: super:
    (
      super
      // {
        ${name} = super.${name}.overrideAttrs override;
      }
    );
in
# A set of overrides for automatically packaged extensions that require some small fixes.
# The input must be an attribute set with the extensions' UUIDs as keys and the extension
# derivations as values. Output is the same, but with patches applied.
#
# Note that all source patches refer to the built extension as published on extensions.gnome.org, and not
# the upstream repository's sources.
super:
lib.trivial.pipe super [
  (patchExtension "apps-menu@gnome-shell-extensions.gcampax.github.com" (old: {
    patches = [
      (replaceVars
        ./extensionOverridesPatches/apps-menu_at_gnome-shell-extensions.gcampax.github.com.patch
        {
          gmenu_path = "${gnome-menus}/lib/girepository-1.0";
        }
      )
    ];
  }))

  (patchExtension "caffeine@patapon.info" (old: {
    meta.maintainers = with lib.maintainers; [ eperuffo ];
  }))

  (patchExtension "dash-to-dock@micxgx.gmail.com" (old: {
    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
  }))

  (patchExtension "ddterm@amezin.github.com" (old: {
    nativeBuildInputs = [
      gobject-introspection
      wrapGAppsHook3
    ];
    buildInputs = [
      vte
      libhandy
      gjs
    ];
    postFixup = ''
      patchShebangs "$out/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm"
      wrapGApp "$out/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm"
    '';
  }))

  (patchExtension "display-brightness-ddcutil@themightydeity.github.com" (old: {
    # Make glib-compile-schemas available
    nativeBuildInputs = [ glib ];
    # Has a hard-coded path to a run-time dependency
    # https://github.com/NixOS/nixpkgs/issues/136111
    postPatch = ''
      substituteInPlace "schemas/org.gnome.shell.extensions.display-brightness-ddcutil.gschema.xml" \
        --replace-fail "/usr/bin/ddcutil" ${lib.getExe ddcutil}
    '';
    postFixup = ''
      rm "$out/share/gnome-shell/extensions/display-brightness-ddcutil@themightydeity.github.com/schemas/gschemas.compiled"
      glib-compile-schemas "$out/share/gnome-shell/extensions/display-brightness-ddcutil@themightydeity.github.com/schemas"
    '';
  }))

  (patchExtension "eepresetselector@ulville.github.io" (old: {
    patches = [
      # Needed to find the currently set preset
      (replaceVars ./extensionOverridesPatches/eepresetselector_at_ulville.github.io.patch {
        easyeffects_gsettings_path = "${glib.getSchemaPath easyeffects}";
      })
    ];
  }))

  (patchExtension "freon@UshakovVasilii_Github.yahoo.com" (old: {
    patches = [
      (replaceVars ./extensionOverridesPatches/freon_at_UshakovVasilii_Github.yahoo.com.patch {
        inherit
          hddtemp
          liquidctl
          lm_sensors
          procps
          smartmontools
          ;
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
    nativeBuildInputs = [ wrapGAppsHook3 ];
    patches = [
      (replaceVars ./extensionOverridesPatches/gtk4-ding_at_smedius.gitlab.com.patch {
        inherit gjs;
        util_linux = util-linux;
        xdg_utils = xdg-utils;
        gtk_update_icon_cache = "${gtk4.out}/bin/gtk4-update-icon-cache";
        update_desktop_database = "${desktop-file-utils.out}/bin/update-desktop-database";
        nautilus_gsettings_path = glib.getSchemaPath nautilus;
      })
    ];
  }))

  (patchExtension "lunarcal@ailin.nemui" (
    old:
    let
      chinese-calendar = stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "chinese-calendar";
        version = "20240107";
        nativeBuildInputs = [
          cpio # used in install.sh
        ];
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "Nei";
          repo = "ChineseCalendar";
          tag = finalAttrs.version;
          hash = "sha256-z8Af9e70bn3ztUZteIEt/b3nJIFosbnoy8mwKMM6Dmc=";
        };
        installPhase = ''
          runHook preInstall
          HOME=$out ./install.sh
          runHook postInstall
        '';
      });
    in
    {
      patches = [
        (replaceVars ./extensionOverridesPatches/lunarcal_at_ailin.nemui.patch {
          chinese_calendar_path = chinese-calendar;
        })
      ];
    }
  ))

  (patchExtension "system-monitor@gnome-shell-extensions.gcampax.github.com" (old: {
    patches = [
      (replaceVars
        ./extensionOverridesPatches/system-monitor_at_gnome-shell-extensions.gcampax.github.com.patch
        {
          gtop_path = "${libgtop}/lib/girepository-1.0";
        }
      )
    ];
  }))

  (patchExtension "system-monitor-next@paradoxxx.zero.gmail.com" (old: {
    patches = [
      (replaceVars ./extensionOverridesPatches/system-monitor-next_at_paradoxxx.zero.gmail.com.patch {
        gtop_path = "${libgtop}/lib/girepository-1.0";
      })
    ];
    meta.maintainers = with lib.maintainers; [ andersk ];
  }))

  (patchExtension "Vitals@CoreCoding.com" (old: {
    patches = [
      (replaceVars ./extensionOverridesPatches/vitals_at_corecoding.com.patch {
        gtop_path = "${libgtop}/lib/girepository-1.0";
      })
    ];
  }))

  (patchExtension "x11gestures@joseexposito.github.io" (old: {
    # Extension can't find Touchegg
    # https://github.com/NixOS/nixpkgs/issues/137621
    postPatch = ''
      substituteInPlace "src/touchegg/ToucheggConfig.js" \
        --replace "GLib.build_filenamev([GLib.DIR_SEPARATOR_S, 'usr', 'share', 'touchegg', 'touchegg.conf'])" "'${touchegg}/share/touchegg/touchegg.conf'"
    '';
  }))

  (patchExtension "pwcalc@thilomaurer.de" {
    postPatch = ''
      # remove unused dangling symlink
      rm settings-importexport.ui
    '';
  })

  (patchExtension "TeaTimer@zener.sbg.at" {
    postPatch = ''
      # remove unused dangling symlink
      rm utilities-teatime.svg
    '';
  })
]
