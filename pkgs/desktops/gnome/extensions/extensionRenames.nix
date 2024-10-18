# A list of UUIDs that have the same pname and we need to rename them
# MAINTENANCE:
# - Every item from ./collisions.json (for the respective Shell version) should have an entry in here
# - Set the value to `null` for filtering (duplicate or unmaintained extensions)
# - Sort the entries in order of appearance in the collisions.json
{
  "Applications_Menu@rmy.pobox.com" = "frippery-applications-menu";
  "apps-menu@gnome-shell-extensions.gcampax.github.com" = "applications-menu";

  "horizontal-workspace-indicator@tty2.io" = "workspace-indicator-2";
  "workspace-indicator@gnome-shell-extensions.gcampax.github.com" = "workspace-indicator";

  "persian-calendar@iamrezamousavi.gmail.com" = "persian-calendar-2";
  "PersianCalendar@oxygenws.com" = "persian-calendar";

  "openweather-extension@jenslody.de" = "openweather";
  "openweather-extension@penguin-teal.github.io" = "openweather-refined";

  "clipboard-indicator@tudmotu.com" = "clipboard-indicator";
  "clipboard-indicator@Dieg0Js.github.io" = "clipboard-indicator-2";

  "system-monitor@gnome-shell-extensions.gcampax.github.com" = "system-monitor";
  "System_Monitor@bghome.gmail.com" = "system-monitor-2";

  "vbox-applet@gs.eros2.info" = "virtualbox-applet";
  "vbox-applet@buba98" = "virtualbox-applet-2";

  "panel-date-format@atareao.es" = "panel-date-format-2";
  "panel-date-format@keiii.github.com" = "panel-date-format";

  "batterytime@typeof.pw" = "battery-time-2";
  "batime@martin.zurowietz.de" = "battery-time";

  # No longer maintained: https://gitlab.com/arnaudr/gnome-shell-extension-kernel-indicator
  "kernel-indicator@elboulangero.gitlab.com" = null;
  "kernel-indicator@pvizc.gitlab.com" = "kernel-indicator";

  "fuzzy-clock@keepawayfromfire.co.uk" = "fuzzy-clock-2";
  "FuzzyClock@johngoetz" = "fuzzy-clock";

  "power-profile-indicator@laux.wtf" = "power-profile-indicator";
  "power-profile@fthx" = "power-profile-indicator-2";

  # ############################################################################
  # These extensions no longer collide. We preserve the old attribute name for backwards compatibility.
  "floatingDock@sun.wxg@gmail.com" = "floating-dock-2";
  "true-color-window-invert@lynet101" = "true-color-window-invert";
  "volume_scroller@francislavoie.github.io" = "volume-scroller-2";

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
