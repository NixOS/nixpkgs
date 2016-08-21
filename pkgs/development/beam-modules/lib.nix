{ pkgs }:

rec {

  callErlang = drv: args: pkgs.callPackage drv {
    mkDerivation = pkgs.callPackage ../../development/interpreters/erlang/generic-builder.nix args;
  };

  callElixir = drv: args: pkgs.callPackage drv {
    mkDerivation = pkgs.callPackage ../../development/interpreters/elixir/generic-builder.nix args;
  };

  overrideElixir = drv: self: super: {
    elixir = callElixir drv { inherit (self) erlang rebar; };
  };

}
