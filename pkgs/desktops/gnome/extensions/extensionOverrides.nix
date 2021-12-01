{ lib
, ddcutil
, gjs
, xprop
}:
let
  # Helper method to reduce redundancy
  patchExtension = name: override: super: (super // {
    ${name} = super.${name}.overrideAttrs override;
  });
in
# A set of overrides for automatically packaged extensions that require some small fixes.
# The input must be an attribute set with the extensions' UUIDs as keys and the extension
# derivations as values. Output is the same, but with patches applied.
#
# Note that all source patches refer to the built extension as published on extensions.gnome.org, and not
# the upstream repository's sources.
super: lib.trivial.pipe super [
  (patchExtension "caffeine@patapon.info" (old: {
    meta.maintainers = with lib.maintainers; [ eperuffo ];
  }))

  (patchExtension "dash-to-dock@micxgx.gmail.com" (old: {
    meta.maintainers = with lib.maintainers; [ eperuffo jtojnar rhoriguchi ];
  }))

  (patchExtension "display-brightness-ddcutil@themightydeity.github.com" (old: {
    # Has a hard-coded path to a run-time dependency
    # https://github.com/NixOS/nixpkgs/issues/136111
    postPatch = ''
      substituteInPlace "extension.js" --replace "/usr/bin/ddcutil" "${ddcutil}/bin/ddcutil"
    '';
  }))

  (patchExtension "gnome-shell-screenshot@ttll.de" (old: {
    # Requires gjs
    # https://github.com/NixOS/nixpkgs/issues/136112
    postPatch = ''
      for file in *.js; do
        substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
      done
    '';
  }))

  (patchExtension "unite@hardpixel.eu" (old: {
    buildInputs = [ xprop ];

    meta.maintainers = with lib.maintainers; [ rhoriguchi ];
  }))
]
