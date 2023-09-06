{ lib, pkgs, fetchFromGitHub }:

lib.makeScope pkgs.newScope (self: with self; {
  # frida uses a "creative" structure in which they have a large repo with a
  # bunch of submodules, and they only tag the main repo, so we have to do
  # this.
  srcs = builtins.fromJSON (builtins.readFile ./versions.json);

  capstone = callPackage ./capstone { inherit (self) srcs; };

  frida-gum-unwrapped = callPackage ./frida-gum { inherit (self) srcs; };
  wrapFridaLib = callPackage ./lib-wrapper.nix { inherit (self) srcs platforms; };
  frida-gum = self.wrapFridaLib { unwrapped = self.frida-gum-unwrapped; devkitName = "frida-gum"; };

  platforms = callPackage ./platforms.nix { };
})
