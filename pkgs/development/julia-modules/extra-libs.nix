# A map from a Julia package (typically a JLL package) to extra libraries
# that they require from Nix.
# The libraries should be strings evaluated in a "with pkgs" context.

{
  # Qt5Base_jll
  # Needs access to dbus or you get "Cannot find libdbus-1 in your system"
  # Repro: build environment with ["Plots"]
  # > using Plots; plot(cos, 0, 2pi)
  "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1" = ["dbus.lib"];

  # Qt6Base_jll
  # Same reason as Qt5Base_jll
  "c0090381-4147-56d7-9ebc-da0b1113ec56" = ["dbus.lib"];
}
