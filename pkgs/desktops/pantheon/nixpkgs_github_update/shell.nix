with import <nixpkgs> {};

let
  inherit (lib) optional;
in

mkShell rec {
  name = "nixpkgs-github-update-shell";

  buildInputs = [
    elixir
    erlang
    common-updater-scripts
  ]
  ++ optional stdenv.isLinux libnotify # For ExUnit Notifier on Linux.
  ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
  ;

}
