# A list of UUIDs that have the same pname and we need to rename them
# MAINTENANCE:
# - Every item from ./collisions.json (for the respective Shell version) should have an entry in here
# - Set the value to `null` for filtering (duplicate or unmaintained extensions)
# - Sort the entries in order of appearance in the collisions.json
{
  "Applications_Menu@rmy.pobox.com" = "frippery-applications-menu";
  "apps-menu@gnome-shell-extensions.gcampax.github.com" = "applications-menu";

  "persian-calendar@iamrezamousavi.gmail.com" = "persian-calendar-2";
  "PersianCalendar@oxygenws.com" = "persian-calendar";

  "system-monitor@gnome-shell-extensions.gcampax.github.com" = "system-monitor";
  "System_Monitor@bghome.gmail.com" = "system-monitor-2";
  "system-monitor@axet.github.com" = "system-monitor-3";

  "FuzzyClock@fire-man-x" = "fuzzy-clock-3";
  "FuzzyClock@johngoetz" = "fuzzy-clock";

  "battery-time@eetumos.github.com" = "battery-time-3";
  "batterytime@typeof.pw" = "battery-time-2";
  "batime@martin.zurowietz.de" = "battery-time";

  "nepali-date@biplab" = "nepali-calendar";
  "nepali-calendar-gs-extension@subashghimire.info.np" = "nepali-calendar-2";

  "mousefollowsfocus@matthes.biz" = "mouse-follows-focus";
  "mouse-follows-focus@crisidev.org" = "mouse-follows-focus-2";

  "power-profile-indicator@laux.wtf" = "power-profile-indicator";
  "power-profile@fthx" = "power-profile-indicator-2";

  "fullscreen-to-empty-workspace@aiono.dev" = "fullscreen-to-empty-workspace";
  "fullscreen-to-empty-workspace2@corgijan.dev" = "fullscreen-to-empty-workspace-2";

  "eur-usd-gshell@vezza.github.com" = "eur-usd";
  "usd-mxn-gshell@kinduff.github.com" = "usd-mxn";

  # ############################################################################
  # These extensions no longer collide. We preserve the old attribute name for backwards compatibility.
  "floatingDock@sun.wxg@gmail.com" = "floating-dock-2";
  "true-color-window-invert@lynet101" = "true-color-window-invert";
  "volume_scroller@francislavoie.github.io" = "volume-scroller-2";
  "openweather-extension@penguin-teal.github.io" = "openweather-refined";

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
