{ lib, newScope, pcre2, libffi, glib }:

let
  staticfy = pkg: pkg.overrideAttrs (oldAttrs: {
    pname = "${oldAttrs.pname}-static";
    configureFlags = oldAttrs.configureFlags or [ ] ++ [ "--disable-shared" ];
    mesonFlags = oldAttrs.mesonFlags or [ ] ++ [ "-Ddefault_library=static" ];
  });
in
lib.makeScope newScope (self: with self; {
  # frida uses a "creative" structure in which they have a large repo with a
  # bunch of submodules, and they only tag the main repo, so we have to do
  # this.
  srcs = builtins.fromJSON (builtins.readFile ./versions.json);

  # HACK: we want static libs that are dynamically linked to glibc. this is a
  # *really* weird requirement, for which it seems like the best option is
  # simply to hack the individual packages in question.
  pcre2-static = staticfy pcre2;

  libffi-static = (staticfy libffi).overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  glib-static = staticfy (glib.override (old: {
    pcre2 = self.pcre2-static;
    libffi = self.libffi-static;
    # docs are not available in static builds and we don't need them anyway.
    withDocs = false;
  }));
  capstone = staticfy (callPackage ./capstone { inherit (self) srcs; });

  frida-gum-unwrapped = (callPackage ./frida-gum { inherit (self) srcs; }).overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags or [ ] ++ [ "-Ddefault_library=static" ];
  });
  wrapFridaLib = callPackage ./lib-wrapper.nix { inherit (self) srcs platforms; };
  frida-gum = self.wrapFridaLib { unwrapped = self.frida-gum-unwrapped; devkitName = "frida-gum"; selfDerivation = self.frida-gum; };

  platforms = callPackage ./platforms.nix { };
})
