{ lib
, ddcutil
, gjs
, xprop
}:
# A set of overrides for automatically packaged extensions that require some small fixes.
# The input must be an attribute set with the extensions' UUIDs as keys and the extension
# derivations as values. Output is the same, but with patches applied.
#
# Note that all source patches refer to the built extension as published on extensions.gnome.org, and not
# the upstream repository's sources.
super: super // {

  "dash-to-dock@micxgx.gmail.com" = super."dash-to-dock@micxgx.gmail.com".overrideAttrs (old: {
    meta.maintainers = with lib.maintainers; [ eperuffo jtojnar rhoriguchi ];
  });

  "display-brightness-ddcutil@themightydeity.github.com" = super."display-brightness-ddcutil@themightydeity.github.com".overrideAttrs (old: {
    # Has a hard-coded path to a run-time dependency
    # https://github.com/NixOS/nixpkgs/issues/136111
    postPatch = ''
      substituteInPlace "extension.js" --replace "/usr/bin/ddcutil" "${ddcutil}/bin/ddcutil"
    '';
  });

  "gnome-shell-screenshot@ttll.de" = super."gnome-shell-screenshot@ttll.de".overrideAttrs (old: {
    # Requires gjs
    # https://github.com/NixOS/nixpkgs/issues/136112
    postPatch = ''
      for file in *.js; do
        substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
      done
    '';
  });

  "unite@hardpixel.eu" = super."unite@hardpixel.eu".overrideAttrs (old: {
    buildInputs = [ xprop ];

    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
  });

}
