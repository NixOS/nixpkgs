{ xwayland }:
xwayland.override (oldArgs: {
  defaultFontPath = "/run/current-system/sw/share/X11/fonts";
})
