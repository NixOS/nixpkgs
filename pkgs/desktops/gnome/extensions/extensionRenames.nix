# A list of UUIDs that have the same pname and we need to rename them
# MAINTENANCE:
# - Every item from ./collisions.json (for the respective Shell version) should have an entry in here
# - Set the value to `null` for filtering (duplicate or unmaintained extensions)
# - Sort the entries in order of appearance in the collisions.json
# - Make a separate section for each GNOME version. Collisions will come back eventually
#   as the extensions are updated.
{

  # ####### GNOME 44 #######

  "apps-menu@gnome-shell-extensions.gcampax.github.com" = "applications-menu";
  "Applications_Menu@rmy.pobox.com" = "frippery-applications-menu";

  "workspace-indicator@gnome-shell-extensions.gcampax.github.com" = "workspace-indicator";
  "horizontal-workspace-indicator@tty2.io" = "workspace-indicator-2";

  "PersianCalendar@oxygenws.com" = "persian-calendar";
  "persian-calendar@iamrezamousavi.gmail.com" = "persian-calendar-2";

  "clipboard-indicator@tudmotu.com" = "clipboard-indicator";
  "clipboard-indicator@Dieg0Js.github.io" = "clipboard-indicator-2";

  "vbox-applet@gs.eros2.info" = "virtualbox-applet";
  "vbox-applet@buba98" = "virtualbox-applet-2";

  "panel-date-format@keiii.github.com" = "panel-date-format";
  "panel-date-format@atareao.es" = "panel-date-format-2";

  "batime@martin.zurowietz.de" = "battery-time";
  "batterytime@typeof.pw" = "battery-time-2";

  # ############################################################################
  # These are conflicts for older extensions (i.e. they don't support the latest GNOME version).
  # Make sure to move them up once they are updated

  # ####### GNOME 43 #######

  "lockkeys@vaina.lt" = "lock-keys";
  "lockkeys@fawtytoo" = "lock-keys-2";

  # DEPRECATED: Use "Caffeine" instead
  "KeepAwake@jepfa.de" = "keep-awake";
  "awake@vixalien.com" = null;

  "noannoyance@sindex.com" = "noannoyance";
  "noannoyance@daase.net" = "noannoyance-2";

  "volume_scroller@trflynn89.pm.me" = "volume-scroller";
  "volume_scroller@francislavoie.github.io" = "volume-scroller-2";

  # no source repository can be found for this extension
  "floating-panel@aylur" = "floating-panel";
  "floating-panel-usedbymyself@wpism" = null;

  # ####### GNOME 42 #######

  "wireguard-indicator@gregos.me" = "wireguard-indicator-2";
  "wireguard-indicator@atareao.es" = "wireguard-indicator";

  "auto-activities@acedron.github.io" = "auto-activities-2";
  "auto-activities@CleoMenezesJr.github.io" = "auto-activities";

  "true-color-invert@jackkenney" = "true-color-invert";
  "true-color-window-invert@lynet101" = "true-color-window-invert";

  "SomaFm-Radio@alireza6677.gmail.com" = "somafm-internet-radio";
  "SomaFm-Radio@cajhne.gmail.com" = "somafm-internet-radio-2";

  # ####### GNOME 41 #######

  "floatingDock@sun.wxg@gmail.com" = "floating-dock-2";
  "floating-dock@nandoferreira_prof@hotmail.com" = "floating-dock";

  "unredirect@vaina.lt" = "disable-unredirect-fullscreen-windows";
  "unredirect@aunetx" = "disable-unredirect-fullscreen-windows-2";

  "fuzzy-clock@keepawayfromfire.co.uk" = "fuzzy-clock-2";
  "FuzzyClock@johngoetz" = "fuzzy-clock";

  # At the moment, ShutdownTimer@deminder is a fork of ShutdownTimer@neumann which adds new features
  # there seem to be upstream plans, so this should be checked periodically:
  # https://github.com/Deminder/ShutdownTimer https://github.com/neumann-d/ShutdownTimer/pull/46
  "ShutdownTimer@neumann" = null;
  "shutdown-timer-gnome-shell-extension" = "shutdowntimer-2";
  "ShutdownTimer@deminder" = "shutdowntimer";

  # ####### GNOME 40 #######

  "system-monitor@paradoxxx.zero.gmail.com" = "system-monitor"; # manually packaged
  "System_Monitor@bghome.gmail.com" = "system-monitor-2";

  "Hide_Activities@shay.shayel.org" = "hide-activities-button";
  "hide-activities-button@nmingori.gnome-shell-extensions.org" = "hide-activities-button-2";

  "extension-list@tu.berry" = "extension-list";
  "screen-lock@garciabaameiro.com" = "screen-lock"; # Don't know why they got 'extension-list' as slug

  # ####### GNOME 3.38 #######

  "bottompanel@tmoer93" = "bottompanel";
  "bottom-panel@sulincix" = "bottompanel-2";

  # See https://github.com/pbxqdown/gnome-shell-extension-transparent-window/issues/12#issuecomment-800765381
  "transparent-window@pbxqdown.github.com" = "transparent-window";
  "transparentwindows.mdirshad07" = null;

  # Forks of each other, azan@faissal.bensefia.id is more recent
  "azan@faissal.bensefia.id" = "azan-islamic-prayer-times";
  "azan@hatem.masmoudi.org" = null;

  # That extension is broken because of https://github.com/NixOS/nixpkgs/issues/118612
  "flypie@schneegans.github.com" = null;

  # ############################################################################
  # Overrides for extensions that were manually packaged in the past but are gradually
  # being replaced by automatic packaging where possible.
  #
  # The manually packaged ones:
  "EasyScreenCast@iacopodeenosee.gmail.com" = "easyScreenCast"; # extensionPortalSlug is "easyscreencast"
  "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com" = "fuzzy-app-search"; # extensionPortalSlug is "gnome-fuzzy-app-search"
  "TopIcons@phocean.net" = "topicons-plus"; # extensionPortalSlug is "topicons"
  "no-title-bar@jonaspoehler.de" = "no-title-bar"; # extensionPortalSlug is "no-title-bar-forked"
  # These extensions are automatically packaged at the moment. We preserve the old attribute name
  # for backwards compatibility.
  "appindicatorsupport@rgcjonas.gmail.com" = "appindicator"; # extensionPortalSlug is "appindicator-support"
  "drawOnYourScreen@abakkk.framagit.org" = "draw-on-your-screen"; # extensionPortalSlug is "draw-on-you-screen"
  "timepp@zagortenay333" = "timepp"; # extensionPortalSlug is "time"
  "windowIsReady_Remover@nunofarruca@gmail.com" = "window-is-ready-remover"; # extensionPortalSlug is "window-is-ready-notification-remover"
}
